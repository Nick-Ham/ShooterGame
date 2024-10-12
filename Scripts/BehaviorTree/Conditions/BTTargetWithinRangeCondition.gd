extends BTNode
class_name BTTargetWithinRangeCondition

@export_category("Config")
@export var targetDistance : float = 10.0

func updateNode(_inDelta : float) -> BehaviorTree.TreeResult:
	var character : Character = Character.getOwningCharacter(get_parent())
	if !character:
		push_error("BTNode attempting to evaluate under a non-character")
		return BehaviorTree.TreeResult.FAILURE

	var controller : AIController = Controller.getController(character) as AIController
	if !controller:
		return BehaviorTree.TreeResult.FAILURE

	var target : Node3D = controller.getTarget()
	if !is_instance_valid(target):
		return BehaviorTree.TreeResult.FAILURE

	var distanceSquared : float = controller.getTargetPosition().distance_squared_to(character.getHeadGlobalPosition())
	if distanceSquared > pow(targetDistance, 2):
		return BehaviorTree.TreeResult.FAILURE

	return BehaviorTree.TreeResult.SUCCESS
