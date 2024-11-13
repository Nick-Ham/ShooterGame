extends Area3D
class_name ItemPickup

@export_category("Config")
@export var item : Item

@export_category("Anim")
@export var animationSpeed : float = 0.25

@export_category("Ref")
@export var animationPlayer : AnimationPlayer

const animationKey : String = "HoverAndSpin"

func _ready() -> void:
	assert(animationPlayer)

	animationPlayer.speed_scale = animationSpeed
	animationPlayer.play(animationKey)

	Util.safeConnect(body_entered, on_body_entered)


func on_body_entered(inBody : Node3D) -> void:
	var itemManager : ItemManager = Util.getChildOfType(inBody, ItemManager)
	if !itemManager:
		return

	itemManager.addItem(item)
	queue_free()
