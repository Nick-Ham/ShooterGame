extends BTNode
class_name BTHasInvestigations

@onready var investigationManager : AIInvestigationManager = Util.getChildOfType(owningCharacter, AIInvestigationManager)

func updateNode(_inDelta : float) -> BTTickResult:
	if investigationManager.hasInvestigations():
		return succeed()

	return fail()
