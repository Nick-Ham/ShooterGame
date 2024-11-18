extends Area3D
class_name ItemPickup

@export_category("Config")
@export var item : Item

@export_category("Anim")
@export var animationSpeed : float = 0.25

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var pivot : Node3D

const animationKey : String = "HoverAndSpin"

func _ready() -> void:
	assert(animationPlayer)

	if !item or !item.validate():
		print_debug("Missing item, deleting itempickup.")
		queue_free()
		return

	var keyModel : Node = item.getModel().instantiate()
	pivot.add_child(keyModel)

	animationPlayer.speed_scale = animationSpeed
	animationPlayer.play(animationKey)

	Util.safeConnect(body_entered, on_body_entered)

func on_body_entered(inBody : Node3D) -> void:
	var itemManager : ItemManager = Util.getChildOfType(inBody, ItemManager)
	if !itemManager:
		return

	itemManager.addItem(item)
	EnvironmentEventBus.addItemPickup(inBody, item)

	queue_free()
