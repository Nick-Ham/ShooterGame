@tool
extends BTCondition

@export var targetVar : String = &"target"

func _generate_name() -> String:
	return "HasTarget %s" % LimboUtility.decorate_var(targetVar)

func _tick(_delta: float) -> Status:
	if !blackboard.has_var(targetVar):
		return Status.FAILURE

	var target : Variant = blackboard.get_var(targetVar)
	if !Util.isValid(target):
		return Status.FAILURE

	return Status.SUCCESS
