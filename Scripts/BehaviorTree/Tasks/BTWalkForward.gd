extends BTNode
class_name BTWalkForward

func updateNode(inDelta : float) -> BTTickResult:
	var controller : AIController = Util.getChildOfType(owningCharacter, AIController)
	if !controller:
		push_warning("BTNode running without an AIController")
		return fail()

	controller.setControlDirectionSmooth(Vector2.UP, inDelta)
	targeter.acquireTarget()

	return run()
