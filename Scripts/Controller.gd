extends Node
class_name Controller

var inputDirection : Vector2 = Vector2()

signal input_direction_changed(newDirection : Vector2)
signal shoot_changed(isShooting : bool)
signal jump_changed(isJumping : bool)
signal crouch_changed(isCrouching : bool)
signal reload_changed(isReloading : bool)
signal interact_changed(inIsInteracting : bool)

signal weapon1_triggered
signal weapon2_triggered
signal weapon3_triggered
signal weapon4_triggered
signal weapon5_triggered

func getInputDirection() -> Vector2:
	return inputDirection

static func getController(inParent : Node3D) -> Controller:
	for child : Node in inParent.get_children():
		var childAsController : Controller = child as Controller
		if childAsController:
			return childAsController

	return null

func getIsCrouching() -> bool:
	return false

func getIsJumping() -> bool:
	return false

func getIsShooting() -> bool:
	return false

func getAimDirection() -> Vector3:
	return Vector3()

func getAimCastResult(_inBloom : float = 0.0) -> RayCastResult:
	return RayCastResult.new()

func detach() -> void:
	input_direction_changed.emit(Vector2())
	queue_free()
