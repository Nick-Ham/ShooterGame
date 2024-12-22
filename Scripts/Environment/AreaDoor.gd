extends StaticBody3D
class_name AreaDoor

@export_category("Config")
@export var doorKey : String = ""
@export var animationSpeed : float = 3.0

@export_category("Ref")
@export var playerDetector : Area3D
@export var animationPlayer : AnimationPlayer
@export var particles : GPUParticles3D

const toggleDoorAnimKey : String = "ToggleDoor"
const failOpenAnimKey : String = "FailOpen"

const playerDetectorCollisionMask : int = 2

var isOpen : bool = false
var isLocked : bool = true

func _ready() -> void:
	assert(playerDetector)
	assert(animationPlayer)
	assert(particles)

	playerDetector.collision_layer = 0
	playerDetector.collision_mask = playerDetectorCollisionMask

	animationPlayer.speed_scale = animationSpeed

	lockDoor()

	Util.safeConnect(playerDetector.body_entered, on_body_entered)

	var eventBus : EnvironmentEventBus = Game.getGame(get_tree()).getLevel().getEnvironmentEventBus()
	Util.safeConnect(eventBus.item_picked_up, on_item_picked_up)

func lockDoor() -> void:
	particles.emitting = false
	isLocked = true

func unlockDoor() -> void:
	particles.emitting = true
	isLocked = false

func on_item_picked_up(_inSource : Node3D, inItem : Item) -> void:
	var itemAsKey : KeyItem = inItem as KeyItem
	if !itemAsKey:
		return

	if itemAsKey.doorKey != doorKey:
		return

	unlockDoor()

func openDoor() -> void:
	animationPlayer.play(toggleDoorAnimKey)
	particles.emitting = false
	isOpen = true

func on_body_entered(_inBody : Node3D) -> void:
	tryOpenDoor()

func tryOpenDoor() -> void:
	if isOpen:
		return

	if isLocked:
		animationPlayer.play(failOpenAnimKey)
		return

	var nodes : Array[Node3D] = playerDetector.get_overlapping_bodies()
	for node : Node3D in nodes:
		var itemManager : ItemManager = Util.getChildOfType(node, ItemManager)
		if !itemManager:
			continue

		for item : Item in itemManager.getItems():
			var keyItem : KeyItem = item as KeyItem
			if !keyItem || keyItem.doorKey != doorKey:
				continue

			openDoor()
			return

	return
