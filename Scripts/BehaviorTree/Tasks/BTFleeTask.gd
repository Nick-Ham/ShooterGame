extends BTNode
class_name BTFleeTask

func updateNode(inDelta : float) -> BehaviorTree.TreeResult:
	var character : Character = Character.getOwningCharacter(get_parent())
	if !character:
		push_error("BTNode attempting to evaluate under a non-character")
		return BehaviorTree.TreeResult.FAILURE

	var controller : AIController = Controller.getController(character) as AIController
	if !controller:
		return BehaviorTree.TreeResult.FAILURE

	var direction : Vector2 = controller.getDirectionFromNavigation()
	controller.setControlDirectionSmooth(-direction, inDelta)

	return BehaviorTree.TreeResult.RUNNING
