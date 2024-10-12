extends Node3D
class_name PhysicsInterpolator3D

@export_category("Config")
@export var target : Node3D
@export var ignoreRotation : bool = false

var previousTransform : Transform3D
var currentTransform : Transform3D

func _ready() -> void:
	if !target:
		target = get_parent()

	set_as_top_level(true)

	global_transform = target.global_transform
	previousTransform = global_transform
	currentTransform = global_transform

func _physics_process(_delta: float) -> void:
	previousTransform = currentTransform
	currentTransform = target.global_transform

func _process(_delta : float) -> void:
	var previousRotation : Vector3 = global_rotation

	var physicsFrameFraction : float = Engine.get_physics_interpolation_fraction()
	global_transform = previousTransform.interpolate_with(currentTransform, clampf(physicsFrameFraction, 0.0, 1.0))

	if ignoreRotation:
		global_rotation = previousRotation
