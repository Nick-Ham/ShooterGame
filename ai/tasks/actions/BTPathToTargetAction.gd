@tool
extends BTAction
class_name BTPathToTargetAction

var stopShootingPattern : AIShootPattern = null

@export_category("Config")
@export var minDistance : float = 5.0
@export var shootPattern : AIShootPattern

@export_category("Blackboard")
@export var targetVar : String = &"target"
@export var controllerVar : String = &"controller"
@export var shootControllerVar : String = &"shootController"
@export var navControllerVar : String = &"navController"

var target : Character = null

func _generate_name() -> String:
	return "PathToTarget %s" % LimboUtility.decorate_var(targetVar)

func _setup() -> void:
	stopShootingPattern = preload("res://Data/ShootPatterns/StopShooting.tres")

func _enter() -> void:
	return

func _exit() -> void:
	var shootController : AIShootController = blackboard.get_var(shootControllerVar) as AIShootController
	shootController.addPattern(stopShootingPattern)

	if !BTUtil.isValidBlackboard(blackboard, controllerVar, AIController):
		return

	var controller : AIController = blackboard.get_var(controllerVar) as AIController
	controller.setControlDirection(Vector2())

func _tick(_delta: float) -> Status:
	if !blackboard.has_var(targetVar):
		return Status.FAILURE

	target = blackboard.get_var(targetVar) as Character

	if !Util.isValid(target):
		return Status.FAILURE

	var agentAsCharacter : Character = agent as Character

	if !BTUtil.isValidBlackboard(blackboard, controllerVar, AIController):
		return Status.FAILURE

	var controller : Variant = blackboard.get_var(controllerVar) as AIController

	var distanceSquared : float = target.global_position.distance_squared_to(agentAsCharacter.global_position)
	if distanceSquared < pow(minDistance, 2.0):
		return Status.SUCCESS

	var navController : NavigationController = blackboard.get_var(navControllerVar) as NavigationController
	navController.updateNavTarget(target.global_position)
	controller.setControlDirection(navController.getDirectionFromNavigation())

	if is_instance_valid(shootPattern):
		var shootPatternToUse : AIShootPattern = shootPattern if agentAsCharacter.canSee(target) else stopShootingPattern
		var shootController : AIShootController = blackboard.get_var(shootControllerVar) as AIShootController
		shootController.addPattern(shootPatternToUse)

	return Status.RUNNING
