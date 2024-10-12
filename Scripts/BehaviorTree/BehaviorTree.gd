extends Node
class_name BehaviorTree

@export_category("Config")
@export var enabled : bool = true

var rootNode : BTNode = null

enum TreeResult {
	SUCCESS,
	FAILURE,
	RUNNING
}

func _ready() -> void:
	rootNode = get_child(0)

func _physics_process(delta: float) -> void:
	if !enabled:
		return

	if !is_instance_valid(rootNode):
		return

	var result : TreeResult = rootNode.updateNode(delta)
