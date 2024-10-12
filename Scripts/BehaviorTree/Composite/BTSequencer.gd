extends BTNode
class_name BTSequencer

func updateNode(inDelta : float) -> BehaviorTree.TreeResult:
	var children : Array[Node] = get_children()
	children.reverse()

	while !children.is_empty():
		var currentBTNode : Node = children.pop_back() as BTNode
		if !is_instance_valid(currentBTNode):
			continue

		var result : BehaviorTree.TreeResult = currentBTNode.updateNode(inDelta)

		match result:
			BehaviorTree.TreeResult.SUCCESS:
				continue

			BehaviorTree.TreeResult.FAILURE:
				return BehaviorTree.TreeResult.FAILURE

			BehaviorTree.TreeResult.RUNNING:
				return BehaviorTree.TreeResult.RUNNING

			_:
				continue

	return BehaviorTree.TreeResult.FAILURE
