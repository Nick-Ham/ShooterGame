extends Area3D
class_name ItemPickup

@export_category("Config")
@export var item : Item
@export var useDespawnTimer : bool = true

@export_category("Anim")
@export var animationSpeed : float = 0.25
@export var flashShader : Shader

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var pivot : Node3D
@export var despawnTimer : Timer
@export var flagMesh : MeshInstance3D

const animationKey : String = "HoverAndSpin"
const flashShaderColorKey : String = "FlashColor"

var flashShaders : Array[ShaderMaterial] = []

func _ready() -> void:
	assert(animationPlayer)
	assert(despawnTimer)

	setItem(item)

	Util.safeConnect(body_entered, on_body_entered)

	if useDespawnTimer:
		Util.safeConnect(despawnTimer.timeout, on_despawnTimer_timeout)

func on_despawnTimer_timeout() -> void:
	queue_free()

func setColor(inColor : Color) -> void:
	var flagMaterial : StandardMaterial3D = flagMesh.get_surface_override_material(0) as StandardMaterial3D
	flagMaterial.albedo_color = inColor

	for material : ShaderMaterial in flashShaders:
		material.set_shader_parameter(flashShaderColorKey, inColor)

func setItem(inItem : Item) -> void:
	if !inItem:
		push_error("Tried to set item with no valid item.")
		return

	item = inItem

	var model : Node = item.getModel().instantiate()
	pivot.add_child(model)

	assert(item.useHover(), "Hover controls not implemented.")

	animationPlayer.speed_scale = animationSpeed
	animationPlayer.play(animationKey)

	addFlashShader(model)
	setColor(Item.getCategoryColor(item.getItemCategory()))

func addFlashShader(node : Node) -> void:
	var meshInstance : MeshInstance3D = node as MeshInstance3D
	if (meshInstance):
		var materialOverlay : ShaderMaterial = ShaderMaterial.new()
		flashShaders.append(materialOverlay)
		materialOverlay.shader = flashShader
		meshInstance.material_overlay = materialOverlay

	for child : Node in node.get_children():
		addFlashShader(child)

func on_body_entered(inBody : Node3D) -> void:
	var itemManager : ItemManager = Util.getChildOfType(inBody, ItemManager)
	if !itemManager:
		return

	itemManager.addItem(item)
	EnvironmentEventBus.addItemPickup(inBody, item)

	queue_free()
