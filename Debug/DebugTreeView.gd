extends BehaviorTreeView
class_name DebugTreeView

@export_category("Config")
@export var btPlayer : BTPlayer

func _ready() -> void:
	assert(btPlayer)

func _physics_process(_delta: float) -> void:
	if !Util.isValid(btPlayer):
		return

	update_tree(BehaviorTreeData.create_from_bt_instance(btPlayer.get_bt_instance()))
