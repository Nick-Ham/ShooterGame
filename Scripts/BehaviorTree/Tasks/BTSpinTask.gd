extends BTNode
class_name BTSpinTask

@export_category("Config")
@export var spinSpeed : float = 5.0

func updateNode(inDelta : float) -> BehaviorTree.TreeResult:
	var character : Character = Character.getOwningCharacter(get_parent())
	if !character:
		push_error("BTNode attempting to evaluate under a non-character")
		return BehaviorTree.TreeResult.FAILURE

	var controller : AIController = Controller.getController(character) as AIController
	if !controller:
		return BehaviorTree.TreeResult.FAILURE

	controller.turn(spinSpeed * inDelta)
	controller.setControlDirection(Vector2())

	return BehaviorTree.TreeResult.RUNNING
