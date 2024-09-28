extends Node
class_name Controller

var inputDirection : Vector2 = Vector2()

signal input_direction_changed(newDirection : Vector2)
signal shoot_changed(isShooting : bool)
signal jump_changed(isJumping : bool)

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

func getAimCastResult() -> RayCastResult:
	return RayCastResult.new()
