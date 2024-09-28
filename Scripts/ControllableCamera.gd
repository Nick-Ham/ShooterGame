extends Camera3D
class_name ControllableCamera

@export_category("Config")
@export var headPunch : Punch
@export var characterStateManager : CharacterStateManager

var headPunchEnabled : bool = false

func _ready() -> void:
	if headPunch == null:
		return

	assert(characterStateManager, "Must have CharacterStateManager if using headpunch.")

	headPunchEnabled = true
	Util.safeConnect(characterStateManager.head_punch_triggered, on_head_punch_triggered)

func on_head_punch_triggered(inPunch : Vector2) -> void:
	headPunch.addPunch(inPunch)
