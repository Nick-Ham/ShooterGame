extends BTNode
class_name BTChase

@onready var stopShootingShootPattern : AIShootPattern = preload("res://Data/ShootPatterns/StopShooting.tres")

@onready var shootController : AIShootController = Util.getChildOfType(owningCharacter, AIShootController)
@onready var navigationController : NavigationController = Util.getChildOfType(owningCharacter, NavigationController)

func updateNode(inDelta : float) -> BTTickResult:
	var controller : AIController = Util.getChildOfType(owningCharacter, AIController)
	if !controller:
		push_warning("BTNode running without an AIController")
		return fail()

	var target : Node = targeter.getTarget()
	if !target:
		return fail()

	var targetPosition : Vector3 = target.global_position

	navigationController.updateNavTarget(targetPosition)
	navigationController.getNextNavigationPoint()

	var navDirection : Vector2 = navigationController.getDirectionFromNavigation()
	controller.setControlDirectionSmooth(navDirection, inDelta)

	shootController.addPattern(stopShootingShootPattern)

	return succeed()
