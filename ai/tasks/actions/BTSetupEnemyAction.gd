@tool
extends BTAction
class_name BTSetupEnemyAction

@export_category("Blackboard")
@export var controllerVar : String = &"controller"
@export var shootControllerVar : String = &"shootController"
@export var navControllerVar : String = &"navController"

func _generate_name() -> String:
	return "SetupEnemy"

func _setup() -> void:
	blackboard.set_var(controllerVar, Util.getChildOfType(agent, AIController))
	blackboard.set_var(navControllerVar, Util.getChildOfType(agent, NavigationController))
	blackboard.set_var(shootControllerVar, Util.getChildOfType(agent, AIShootController))

func _tick(_delta: float) -> Status:
	var agentAsCharacter : Character = agent as Character
	if !agentAsCharacter:
		push_error("No character agent found.")
		return Status.FAILURE

	var controller : AIController = Controller.getController(agentAsCharacter)
	if !controller:
		push_error("BT will not work without a controller to bind.")
		return Status.FAILURE

	blackboard.set_var(controllerVar, controller)
	return Status.SUCCESS
