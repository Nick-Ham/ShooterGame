@tool
extends BTCondition

@export_category("Config")
@export var useMinDistance : bool = false
@export var minDistance : float = 0.0
@export var useMaxDistance : bool = false
@export var maxDistance : float = 0.0

@export_category("Blackboard")
@export var targetVar : String = &"target"

func _generate_name() -> String:
	return "WithinRange to %s" % LimboUtility.decorate_var(targetVar)

func _setup() -> void:
	if useMinDistance and useMaxDistance and maxDistance < minDistance:
		push_error("WithinRange will not work properly with a maxDistance < minDistance: %s" % agent.name)

func _tick(_delta: float) -> Status:
	if !(useMinDistance or useMaxDistance):
		push_warning("Must select at least one, useMin or useMax")
		return Status.FAILURE

	if !blackboard.has_var(targetVar):
		push_warning("TargetVar not found %s" % targetVar)
		return Status.FAILURE

	var target : Node3D = blackboard.get_var(targetVar) as Node3D
	if !Util.isValid(target):
		return Status.FAILURE

	var agentAsCharacter : Character = agent as Character
	var distanceSquared : float = agentAsCharacter.global_position.distance_squared_to(target.global_position)

	if useMinDistance and distanceSquared < pow(minDistance, 2.0):
		return Status.FAILURE

	if useMaxDistance and distanceSquared > pow(maxDistance, 2.0):
		return Status.FAILURE

	return Status.SUCCESS
