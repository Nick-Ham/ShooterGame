extends BTNode
class_name BTIdle

@onready var emptyShootPattern : Resource = preload("res://Data/ShootPatterns/StopShooting.tres")

@onready var shootController : AIShootController = Util.getChildOfType(owningCharacter, AIShootController)

func updateNode(inDelta : float) -> BTTickResult:
	var controller : AIController = Util.getChildOfType(owningCharacter, AIController)
	if !controller:
		push_warning("BTNode running without an AIController")
		return fail()

	controller.setControlDirectionSmooth(Vector2(), inDelta)

	shootController.addPattern(emptyShootPattern)

	return run()
