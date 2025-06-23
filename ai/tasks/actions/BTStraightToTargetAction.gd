@tool
extends BTAction

var controllerVar : String = &"controller"
@export var targetVar : String = &"target"

@export_category("Config")
@export_group("Range")
@export var stopAtMin : bool = false
@export var minDistance : float = 0.0

var controller : AIController = null
var agentAsCharacter : Character = null

func _enter() -> void:
	controller = blackboard.get_var(controllerVar) as Controller
	agentAsCharacter = agent as Character

func _generate_name() -> String:
	return "StraightToTarget %s" % LimboUtility.decorate_var(targetVar)

func _tick(_delta: float) -> Status:
	if !blackboard.has_var(targetVar):
		return Status.FAILURE

	var target : Variant = blackboard.get_var(targetVar)
	if !Util.isValid(target):
		return Status.FAILURE

	var targetAsCharacter : Character = target as Character

	if stopAtMin:
		var distanceSquared : float = targetAsCharacter.global_position.distance_squared_to(agentAsCharacter.global_position)
		if distanceSquared < pow(minDistance, 2.0):
			return Status.SUCCESS

	var vectorToTarget : Vector3 = (targetAsCharacter.global_position - agentAsCharacter.global_position).normalized()
	controller.setControlDirection(Vector2(0, -1))

	return Status.RUNNING
