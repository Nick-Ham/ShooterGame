extends BTNode
class_name BTSequencer

func updateNode(inDelta : float) -> BTTickResult:
	var children : Array[Node] = get_children()
	children.reverse()

	while !children.is_empty():
		var currentBTNode : Node = children.pop_back() as BTNode
		if !is_instance_valid(currentBTNode):
			continue

		var result : BTTickResult = currentBTNode.updateNode(inDelta)
		if !result:
			push_error("BTNode should always evaluate to a BTTickResult type. Received null")
			return

		match result.tickResult:
			TickResult.SUCCESS:
				continue

			TickResult.FAILURE:
				return fail()

			TickResult.RUNNING:
				return result

			_:
				continue

	return fail()
