extends BTNode
class_name BTEventTrigger

signal event_trigger

func updateNode(_inDelta : float) -> BTTickResult:
	var controller : AIController = Util.getChildOfType(owningCharacter, AIController)
	if !controller:
		push_warning("BTNode running without an AIController")
		return fail()

	event_trigger.emit()

	return succeed()
