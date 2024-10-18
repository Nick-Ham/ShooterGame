extends BTNode
class_name BTSelector

func updateNode(inDelta : float) -> BTTickResult:
	var children : Array[Node] = get_children()
	children.reverse()

	while !children.is_empty():
		var currentBTNode : Node = children.pop_back() as BTNode
		if !is_instance_valid(currentBTNode):
			continue

		var result : BTTickResult = currentBTNode.updateNode(inDelta)

		match result.tickResult:
			TickResult.SUCCESS:
				return succeed()

			TickResult.FAILURE:
				continue

			TickResult.RUNNING:
				return result

			_:
				continue

	return fail()
