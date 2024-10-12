extends BTNode
class_name BTStrafe

@export_category("Config")
@export var strafeLeft : bool = false

func updateNode(inDelta : float) -> BehaviorTree.TreeResult:
	var character : Character = Character.getOwningCharacter(get_parent())
	if !character:
		push_error("BTNode attempting to evaluate under a non-character")
		return BehaviorTree.TreeResult.FAILURE

	var controller : AIController = Controller.getController(character) as AIController
	if !controller:
		return BehaviorTree.TreeResult.FAILURE

	var xDirection : float = -1 if strafeLeft else 1
	controller.setControlDirectionSmooth(Vector2(xDirection, 0), inDelta)

	return BehaviorTree.TreeResult.RUNNING
