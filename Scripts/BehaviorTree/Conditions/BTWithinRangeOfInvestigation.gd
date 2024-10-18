extends BTNode
class_name BTWithinRangeOfInvestigation

@export_category("Config")
@export var targetDistance : float = 0.5

@onready var investigationManager : AIInvestigationManager = Util.getChildOfType(owningCharacter, AIInvestigationManager)

func updateNode(_inDelta : float) -> BTTickResult:
	var currentInvestigation : AIInvestigationManager.Investigation = investigationManager.getCurrentInvestigation()
	if !currentInvestigation:
		return fail()

	var distanceSquaredToTarget : float = owningCharacter.global_position.distance_squared_to(currentInvestigation.positionOfInterest)
	if distanceSquaredToTarget < pow(targetDistance, 2):
		return succeed()

	return fail()
