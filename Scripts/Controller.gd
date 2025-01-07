extends Node
class_name Controller

var inputDirection : Vector2 = Vector2()

signal input_direction_changed(newDirection : Vector2)
signal shoot_changed(isShooting : bool)
signal jump_changed(isJumping : bool)
signal reload_changed(isReloading : bool)
signal interact_changed(inIsInteracting : bool)

func getInputDirection() -> Vector2:
	return inputDirection

static func getController(inParent : Node3D) -> Controller:
	for child : Node in inParent.get_children():
		var childAsController : Controller = child as Controller
		if childAsController:
			return childAsController

	return null

func getIsShooting() -> bool:
	return false

func getAimCastResult(_inBloom : float = 0.0) -> RayCastResult:
	return RayCastResult.new()

func detach() -> void:
	input_direction_changed.emit(Vector2())
	queue_free()
