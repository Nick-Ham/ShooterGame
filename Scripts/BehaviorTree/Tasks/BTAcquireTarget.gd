extends BTNode
class_name BTAcquireTarget

func updateNode(_inDelta : float) -> BTTickResult:
	var foundTarget : Node3D = targeter.acquireTarget()
	if foundTarget:
		return succeed()

	return fail()
