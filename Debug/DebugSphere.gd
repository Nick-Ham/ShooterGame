extends Node3D
class_name DebugSphere

@onready var debugMaterial : StandardMaterial3D = preload("res://Debug/DebugRedMaterial.tres")

const radius : float = 0.1
const lifetime : float = 2.0

func _ready() -> void:
	var newSphere : CSGSphere3D = CSGSphere3D.new()
	newSphere.radius = radius
	newSphere.material = debugMaterial
	newSphere.use_collision = false
	add_child(newSphere)
	newSphere.position = Vector3()

	await get_tree().create_timer(lifetime).timeout
	queue_free()
