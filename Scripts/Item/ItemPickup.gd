extends Area3D
class_name ItemPickup

@export_category("Config")
@export var item : Item

@export_category("Anim")
@export var animationSpeed : float = 0.25

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var pivot : Node3D
@export var despawnTimer : Timer

const animationKey : String = "HoverAndSpin"

func _ready() -> void:
	assert(animationPlayer)
	assert(despawnTimer)

	setItem(item)

	Util.safeConnect(body_entered, on_body_entered)
	Util.safeConnect(despawnTimer.timeout, on_despawnTimer_timeout)

func on_despawnTimer_timeout() -> void:
	queue_free()

func setItem(inItem : Item) -> void:
	item = inItem

	var model : Node = item.getModel().instantiate()
	pivot.add_child(model)

	assert(item.useHover(), "Hover controls not implemented.")

	animationPlayer.speed_scale = animationSpeed
	animationPlayer.play(animationKey)

func on_body_entered(inBody : Node3D) -> void:
	var itemManager : ItemManager = Util.getChildOfType(inBody, ItemManager)
	if !itemManager:
		return

	itemManager.addItem(item)
	EnvironmentEventBus.addItemPickup(inBody, item)

	queue_free()
