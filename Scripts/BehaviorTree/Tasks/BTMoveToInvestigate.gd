extends BTNode
class_name BTMoveToInvestigate

@export_category("Config")
@export var targetDistance : float = 1.0

@onready var investigationManager : AIInvestigationManager = Util.getChildOfType(owningCharacter, AIInvestigationManager)
@onready var navigationController : NavigationController = Util.getChildOfType(owningCharacter, NavigationController)

func updateNode(inDelta : float) -> BTTickResult:
	var currentInvestigation : AIInvestigationManager.Investigation = investigationManager.getCurrentInvestigation()
	if !currentInvestigation:
		return fail()

	var controller : AIController = Util.getChildOfType(owningCharacter, AIController)
	if !controller:
		push_warning("BTNode running without an AIController")
		return fail()

	var distanceSquaredToTarget : float = owningCharacter.global_position.distance_squared_to(currentInvestigation.positionOfInterest)
	if distanceSquaredToTarget < pow(targetDistance, 2):
		controller.setControlDirection(Vector2())
		investigationManager.completeCurrentInvestigation()
		return succeed()

	navigationController.updateNavTarget(currentInvestigation.positionOfInterest)
	var navDirection : Vector2 = navigationController.getDirectionFromNavigation()

	controller.setControlDirectionSmooth(navDirection, inDelta)
	if targeter.acquireTarget():
		controller.setControlDirection(Vector2())

	targeter.forceUpdatePositionOfInterest(currentInvestigation.positionOfInterest)
	owningCharacter.rotateCharacterToTarget(currentInvestigation.positionOfInterest, inDelta)

	return run()
