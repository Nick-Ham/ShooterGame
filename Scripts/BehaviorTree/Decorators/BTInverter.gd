extends BTNode
class_name BTInverter

func updateNode(inDelta : float) -> BehaviorTree.TreeResult:
	var childAsBTNode : BTNode = get_child(0)
	if !is_instance_valid(childAsBTNode):
		return BehaviorTree.TreeResult.FAILURE

	var result : BehaviorTree.TreeResult = childAsBTNode.updateNode(inDelta)
	match result:
		BehaviorTree.TreeResult.SUCCESS:
			return BehaviorTree.TreeResult.FAILURE

		BehaviorTree.TreeResult.FAILURE:
			return BehaviorTree.TreeResult.SUCCESS

		BehaviorTree.TreeResult.RUNNING:
			return BehaviorTree.TreeResult.RUNNING

	return BehaviorTree.TreeResult.FAILURE
