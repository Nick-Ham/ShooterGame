@tool
extends Node
class_name OvershieldMaterialController

@export_category("Ref")
@export var health : Health
@export var animationPlayer : AnimationPlayer
@export var shieldMeshes : Node3D:
	set(newShieldMeshesNode):
		shieldMeshes = newShieldMeshesNode
		updateTrackedMeshes()

@export_category("Material")
@export var colorShift : float = 1.0:
	set(inColorShift):
		colorShift = clampf(inColorShift, 0.0, 1.0)
		updateMaterialProperty("ColorShift", inColorShift)

@export var shieldStrength : float = 1.0:
	set(inShieldStrength):
		shieldStrength = clampf(inShieldStrength, 0.0, 1.0)
		updateMaterialProperty("ShieldStrengthSwitch", inShieldStrength)

@export var flashScalar : float = 1.0:
	set(inFlashScalar):
		flashScalar = inFlashScalar
		updateMaterialProperty("FlashScalar", inFlashScalar)

var trackedMeshes : Array[GeometryInstance3D]
@onready var material : ShaderMaterial = preload("res://Assets/Materials/OvershieldMaterial.tres")


const hitFlashAnimationKey : String = "HitOvershield"

func _exit_tree() -> void:
	resetTrackedMeshes()

func _ready() -> void:
	assert(health)
	assert(animationPlayer)
	assert(shieldMeshes)

	Util.safeConnect(health.health_damaged, on_health_damaged)

	updateTrackedMeshes()

func on_health_damaged(inDamage : float, remainingHealth : float) -> void:
	animationPlayer.play(hitFlashAnimationKey)

func updateMaterialProperty(inPropertyName : String, inPropertyValue : float) -> void:
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
