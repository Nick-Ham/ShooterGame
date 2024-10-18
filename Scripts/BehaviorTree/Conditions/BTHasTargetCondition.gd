extends BTNode
class_name BTHasTargetCondition

func updateNode(_inDelta : float) -> BTTickResult:
	if targeter.hasTarget():
		return succeed()

	return fail()
