@tool
extends Node
class_name OvershieldMaterialController

@export_category("Ref")
@export var health : OvershieldHealth
@export var animationPlayer : AnimationPlayer
@export var shieldMeshes : Node3D:
	set(newShieldMeshesNode):
		shieldMeshes = newShieldMeshesNode
		updateTrackedMeshes()

@export_category("Material")
@export var colorShift : float = 1.0:
	set(inColorShift):
		colorShift = clampf(inColorShift, 0.0, 1.0)
		updateMaterialProperty(colorShiftPropertyKey, inColorShift)

@export var shieldStrength : float = 1.0:
	set(inShieldStrength):
		shieldStrength = clampf(inShieldStrength, 0.0, 1.0)
		updateMaterialProperty(shieldStrengthPropertyKey, inShieldStrength)

@export var flashStrength : float = 1.0:
	set(inFlashStrength):
		flashStrength = inFlashStrength
		updateMaterialProperty(flashStrengthPropertyKey, inFlashStrength)

var trackedMeshes : Array[GeometryInstance3D]
var materialResource : ShaderMaterial = preload("res://Assets/Materials/OvershieldMaterial.tres")
@onready var material : ShaderMaterial = materialResource.duplicate()

const colorShiftPropertyKey : String = "ColorShift"
const shieldStrengthPropertyKey : String = "ShieldStrengthSwitch"
const flashStrengthPropertyKey : String = "FlashStrength"

const hitFlashAnimationKey : String = "HitOvershield"
const shieldBreakAnimationKey : String = "ShieldBreak"
const shieldResettingAnimationKey : String = "ShieldReset"

func _exit_tree() -> void:
	resetTrackedMeshes()

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	assert(health)
	assert(animationPlayer)
	assert(shieldMeshes)

	Util.safeConnect(health.health_damaged, on_health_damaged)
	Util.safeConnect(health.health_restored, on_health_restored)
	Util.safeConnect(health.health_depleted, on_health_depleted)
	Util.safeConnect(health.shield_resetting, on_shield_resetting)

	updateTrackedMeshes()

func on_health_damaged(_inDamage : float, _remainingHealth : float) -> void:
	if animationPlayer.current_animation == hitFlashAnimationKey and animationPlayer.is_playing():
		animationPlayer.seek(0)
	else:
		animationPlayer.play(hitFlashAnimationKey)

	refreshMaterialParams()

func on_shield_resetting()-> void:
	animationPlayer.play(shieldResettingAnimationKey)

	refreshMaterialParams()

func on_health_restored(_inAmount : float, _inNewHealth : float) -> void:
	refreshMaterialParams()

func on_health_depleted(_inHealth : Health) -> void:
	animationPlayer.play(shieldBreakAnimationKey)

	refreshMaterialParams()

func refreshMaterialParams() -> void:
	if Engine.is_editor_hint():
		return

	colorShift = health.getCurrentHealth() / health.getMaxHealth()

	updateMaterialProperty(colorShiftPropertyKey, colorShift)
	updateMaterialProperty(shieldStrengthPropertyKey, shieldStrength)
	updateMaterialProperty(flashStrengthPropertyKey, flashStrength)

func updateMaterialProperty(inPropertyName : String, inPropertyValue : float) -> void:
	if !material:
		return

	material.set_shader_parameter(inPropertyName, inPropertyValue)

func resetTrackedMeshes() -> void:
	for mesh : GeometryInstance3D in trackedMeshes:
		mesh.material_overlay = null

	trackedMeshes.clear()

func updateTrackedMeshes() -> void:
	resetTrackedMeshes()

	for child : Node in Util.getChildrenRecursive(shieldMeshes):
		var mesh : GeometryInstance3D = child as GeometryInstance3D
		if !mesh:
			continue

		trackedMeshes.append(mesh)

	for mesh : GeometryInstance3D in trackedMeshes:
		mesh.material_overlay = material

	refreshMaterialParams()
