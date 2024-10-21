extends Area3D
class_name CharacterRepelArea

@export_category("Config")
@export var repelStrength : float = 55.0
@export var repelVerticalScalar : float = 0.2

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

const collisionBits : int = 6

func _ready() -> void:
	collision_layer = 0
	collision_mask = collisionBits

func _physics_process(delta: float) -> void:
	var overlappingBodies : Array[Node3D] = get_overlapping_bodies()
	overlappingBodies.erase(owningCharacter)

	for body : Node3D in overlappingBodies:
		var bodyAsCharacter : Character = body as Character
		if !bodyAsCharacter:
			continue

		var vectorTo : Vector3 = owningCharacter.global_position - bodyAsCharacter.global_position
		var distance : float = vectorTo.length()

		#var pushStrength : float = clampf(repelStrength / distance, 0.0, repelStrength * 2) * delta
		var pushStrength : float = clampf(repelStrength * (-log(distance) + 1), 0.0, repelStrength * 2) * delta
		var addedVelocity : Vector3 = -vectorTo.normalized() * pushStrength
		addedVelocity.y = addedVelocity.y * repelVerticalScalar

		bodyAsCharacter.velocity += addedVelocity
