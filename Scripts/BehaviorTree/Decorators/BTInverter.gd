extends BTNode
class_name BTInverter

func updateNode(inDelta : float) -> BTTickResult:
	if get_child_count() < 1:
		return fail()

	var childAsBTNode : BTNode = get_child(0)
	if !is_instance_valid(childAsBTNode):
		return fail()

	var result : BTTickResult = childAsBTNode.updateNode(inDelta)
	match result.tickResult:
		TickResult.SUCCESS:
			return fail()

		TickResult.FAILURE:
			return succeed()

		TickResult.RUNNING:
			return result

	return fail()
