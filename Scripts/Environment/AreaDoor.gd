extends StaticBody3D
class_name AreaDoor

@export_category("Config")
@export var animationSpeed : float = 3.0

@export_category("Ref")
@export var playerDetector : Area3D
@export var animationPlayer : AnimationPlayer
@export var particles : GPUParticles3D

const toggleDoorAnimKey : String = "ToggleDoor"

const playerDetectorCollisionMask : int = 2

var isOpen : bool = false

func _ready() -> void:
	assert(playerDetector)
	assert(animationPlayer)
	assert(particles)

	playerDetector.collision_layer = 0
	playerDetector.collision_mask = playerDetectorCollisionMask

	animationPlayer.speed_scale = animationSpeed
	Util.safeConnect(playerDetector.body_entered, on_body_entered)

func on_body_entered(_inBody : Node3D) -> void:
	if isOpen:
		return
	isOpen = true

	animationPlayer.play(toggleDoorAnimKey)
	particles.emitting = false
