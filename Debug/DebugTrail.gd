extends Node3D
class_name DebugTrail

@onready var debugMaterial : StandardMaterial3D = preload("res://Debug/DebugRedMaterial.tres")

const lifetime : float = 2.0
const trailDetail : float = 0.25
const trailScale : float = 0.005

var points : Array[Vector3] = []
var linePolygon : CSGPolygon3D = null
var path3D : Path3D = null

var linePolygonShape : PackedVector2Array = [
	Vector2(-1, -1),
	Vector2(-1, 1),
	Vector2(1, 1),
	Vector2(1, -1)
]

func _ready() -> void:
	var root : Node = get_tree().current_scene

	linePolygon = CSGPolygon3D.new()
	path3D = Path3D.new()
	path3D.curve = Curve3D.new()

	linePolygon.polygon = getScaledPolygon(trailScale)
	linePolygon.mode = CSGPolygon3D.MODE_PATH
	linePolygon.path_interval = trailDetail
	linePolygon.material = debugMaterial
	linePolygon.use_collision = false
	linePolygon.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	add_child(linePolygon)
	add_child(path3D)

	linePolygon.path_node = path3D.get_path()

	await get_tree().create_timer(lifetime).timeout
	queue_free()

func addPoints(inPoints : Array[Vector3]) -> void:
	path3D.curve.clear_points()

	for point : Vector3 in inPoints:
		path3D.curve.add_point(point)

func getScaledPolygon(inNewScale : float) -> PackedVector2Array:
	var scaledPolygonShape : PackedVector2Array = []

	for vector : Vector2 in linePolygonShape.duplicate():
		scaledPolygonShape.append(vector * inNewScale)

	return scaledPolygonShape
