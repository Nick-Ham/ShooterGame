extends Area3D
class_name LOSTracker

@export_category("Config")
@export var acquireTargetVisionRange : float = PI / 4.0
@export var loseTargetVisionRange : float = PI / 3.0
@export_flags_3d_physics var detectorLayer : int = 6

enum LossReason {
	LOS,
	DISTANCE,
	DESTRUCTION
}

signal character_detected(character : Character)
signal character_lost(character : Character, lossReason : LossReason)

@onready var owningCharacter : Character = Character.getOwningCharacter(self) as Character

var visibleCharacters : Array[Character]

func _ready() -> void:
	collision_layer = 0
	collision_mask = detectorLayer

	Util.safeConnect(body_exited, on_body_exited)

func getVisibleCharacters() -> Array[Character]:
	return visibleCharacters.duplicate()

func on_body_exited(inBody : Node3D) -> void:
	var bodyAsCharacter : Character = inBody as Character
	if !bodyAsCharacter:
		return

	if visibleCharacters.has(bodyAsCharacter):
		character_lost.emit(bodyAsCharacter, LossReason.DISTANCE)

	visibleCharacters.erase(bodyAsCharacter)

func _physics_process(_delta: float) -> void:
	var charactersToRemove : Array[Character]
	for character : Character in visibleCharacters:
		if !owningCharacter.canSee(character, loseTargetVisionRange):
			charactersToRemove.append(character)

	for character : Character in charactersToRemove:
		visibleCharacters.erase(character)
		character_lost.emit(character, LOSTracker.LossReason.LOS)

	var overlappingBodies : Array[Node3D] = get_overlapping_bodies()
	overlappingBodies.erase(owningCharacter)

	for body : Node3D in overlappingBodies:
		var bodyAsCharacter : Character = body as Character
		if !bodyAsCharacter:
			continue

		if charactersToRemove.has(bodyAsCharacter):
			continue

		if visibleCharacters.has(bodyAsCharacter):
			continue

		if !owningCharacter.canSee(bodyAsCharacter, acquireTargetVisionRange):
			continue

		visibleCharacters.append(bodyAsCharacter)
		character_detected.emit(bodyAsCharacter)
