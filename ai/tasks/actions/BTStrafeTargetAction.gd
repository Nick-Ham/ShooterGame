@tool
extends BTAction
class_name BTStrafeTargetAction

var stopShootingPattern : AIShootPattern = null

@export_category("Config")
@export var shootPattern : AIShootPattern
@export var requireSight : bool = true

@export_category("Blackboard")
@export var targetVar : String = &"target"
@export var controllerVar : String = &"controller"
@export var shootControllerVar : String = &"shootController"

var target : Character = null
var strafeLeft : bool = false

var agentAsCharacter : Character = null

func _generate_name() -> String:
	return "StrafeTarget %s" % LimboUtility.decorate_var(targetVar)

func _setup() -> void:
	agentAsCharacter = agent as Character
	stopShootingPattern = preload("res://Data/ShootPatterns/StopShooting.tres")

func _enter() -> void:
	strafeLeft = randf() > 0.5

func _exit() -> void:
	var shootController : AIShootController = blackboard.get_var(shootControllerVar) as AIShootController
	shootController.addPattern(stopShootingPattern)

	if !BTUtil.isValidBlackboard(blackboard, controllerVar, AIController):
		return

	var controller : AIController = blackboard.get_var(controllerVar) as AIController
	controller.setControlDirection(Vector2())

func _tick(delta: float) -> Status:
	if !blackboard.has_var(targetVar):
		return Status.FAILURE

	if !BTUtil.isValidBlackboard(blackboard, targetVar, Character):
		return Status.FAILURE

	target = blackboard.get_var(targetVar) as Character

	if !BTUtil.isValidBlackboard(blackboard, controllerVar, AIController):
		return Status.FAILURE

	var controller : AIController = blackboard.get_var(controllerVar) as AIController

	controller.setControlDirectionSmooth(Vector2(-1.0 if strafeLeft else 1.0, 0.0), delta)

	if is_instance_valid(shootPattern):
		var shootPatternToUse : AIShootPattern = shootPattern if (requireSight and agentAsCharacter.canSee(target)) else stopShootingPattern
		var shootController : AIShootController = blackboard.get_var(shootControllerVar) as AIShootController
		shootController.addPattern(shootPatternToUse)

	updateStrafeLeft()

	return Status.RUNNING

func updateStrafeLeft() -> void:
	var detectorProvider : DetectorProvider = Util.getChildOfType(agentAsCharacter, DetectorProvider)
	if !detectorProvider:
		return

	var canContinue : bool = detectorProvider.getFloorDetector(strafeLeft).is_colliding() and !detectorProvider.getWallDetector(strafeLeft).is_colliding()
	if canContinue:
		return

	strafeLeft = !strafeLeft
