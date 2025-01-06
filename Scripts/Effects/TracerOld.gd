extends Node3D
class_name Tracer

@onready var debugMaterial : StandardMaterial3D = preload("res://Assets/Materials/TracerMaterial.tres")

const trailDetail : float = 100.0 #0.25
const trailScale : float = 0.005

const segmentSpeed : float = 200.0
const segmentLength : float = 3.5

const maxTrailLength : float = 150.0
const minTrailLength : float = 2.0

var points : Array[Vector3] = []
var linePolygon : CSGPolygon3D = null
var path3D : Path3D = null

var linePolygonShape : PackedVector2Array = [
	Vector2(-1, -1),
	Vector2(-1, 1),
	Vector2(1, 1),
	Vector2(1, -1)
]

var originPosition : Vector3 = Vector3()
var hitPosition : Vector3 = Vector3()

var vectorPath : Vector3 = Vector3()

var headProgress : float = 0.0
var tailProgress : float = 0.0

var totalPathLength : float = 0.0

var headComplete : bool = false
var pathReady : bool = false

func setPath(inOriginPosition : Vector3, inHitPosition : Vector3) -> void:
	originPosition = inOriginPosition
	hitPosition = inHitPosition

	vectorPath = hitPosition - originPosition
	totalPathLength = vectorPath.length()

	if totalPathLength < minTrailLength:
		queue_free()
		return

	var vectorFraction : float = maxTrailLength / maxTrailLength
	if vectorFraction < 1.0:
		vectorPath *= vectorFraction

	headProgress += segmentLength

	pathReady = true

func _process(delta: float) -> void:
	if !pathReady:
		return

	var newPoints : Array[Vector3] = [
		originPosition + lerp(Vector3(), vectorPath, clampf(tailProgress / totalPathLength, 0.0, 0.99)),
		originPosition + lerp(Vector3(), vectorPath, clampf(headProgress / totalPathLength, 0.0, 1.0))
	]

	addPoints(newPoints)

	if headProgress < totalPathLength:
		headProgress += segmentSpeed * delta
	else:
		headComplete = true

	if tailProgress < totalPathLength:# || abs(totalPathLength - tailProgress):
		if headProgress - tailProgress > segmentLength or headComplete:
			tailProgress += segmentSpeed * delta
	else:
		queue_free()
		return

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

func addPoints(inPoints : Array[Vector3]) -> void:
	path3D.curve.clear_points()

	for point : Vector3 in inPoints:
		path3D.curve.add_point(point)

func getScaledPolygon(inNewScale : float) -> PackedVector2Array:
	var scaledPolygonShape : PackedVector2Array = []

	for vector : Vector2 in linePolygonShape.duplicate():
		scaledPolygonShape.append(vector * inNewScale)

	return scaledPolygonShape
