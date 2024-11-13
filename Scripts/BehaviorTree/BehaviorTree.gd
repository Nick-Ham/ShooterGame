extends Node
class_name BehaviorTree

@export_category("Config")
@export var enabled : bool = true

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

var rootNode : BTNode = null
var runningNode : BTNode = null

var shouldReset : bool = false

func _ready() -> void:
	rootNode = Util.getChildOfType(self, BTNode)
	process_physics_priority = -1

	Util.safeConnect(owningCharacter.character_destroyed, on_character_destroyed)

func on_character_destroyed(_inCharacter : Character) -> void:
	enabled = false

func _physics_process(delta: float) -> void:
	if !enabled:
		return

	if !is_instance_valid(rootNode):
		return

	var controller : AIController = Util.getChildOfType(get_parent(), AIController)
	if !controller:
		push_warning("Behavior tree enabled with no AIController")
		return

	if shouldReset:
		shouldReset = false
		runningNode = null

	var nodeToUpdate : BTNode = runningNode if is_instance_valid(runningNode) else rootNode
	var result : BTNode.BTTickResult = nodeToUpdate.updateNode(delta)

	match result.tickResult:
		BTNode.TickResult.RUNNING:
			runningNode = result.nodeSource
		_:
			runningNode = null

func interrupt() -> void:
	shouldReset = true

func getActiveNode() -> BTNode:
	return runningNode
