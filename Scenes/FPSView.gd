extends ControllableCamera
class_name FPSView

@export_category("Config")
@export var subViewport : SubViewport
@export var viewportCamera : Camera3D

const cameraRayMax : float = 1000.0

func _ready() -> void:
	super._ready()

	assert(subViewport, "Must assign subviewport in order to function. " + self.name)
	assert(viewportCamera, "Must assign viewportCamera in order to function. " + self.name)

	var viewport : Viewport = get_viewport()
	Util.safeConnect(viewport.size_changed, on_viewport_size_changed)
	refreshSubViewport()

func _process(_delta: float) -> void:
	viewportCamera.global_transform = global_transform

func on_viewport_size_changed() -> void:
	refreshSubViewport()

func refreshSubViewport() -> void:
	var viewport : Viewport = get_viewport()
	subViewport.size = viewport.size

func getCameraCastResult() -> RayCastResult:
	var worldReference : World3D = get_world_3d()
	var spaceState : PhysicsDirectSpaceState3D = worldReference.direct_space_state

	var screenCenter : Vector2 = get_viewport().size / 2.0
	var origin : Vector3 = project_ray_origin(screenCenter)
	var endpoint : Vector3 = project_ray_normal(screenCenter) * cameraRayMax

	var rayQuery : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, endpoint)
	rayQuery.collide_with_bodies = true

	var result : Dictionary = spaceState.intersect_ray(rayQuery)

	if result.is_empty():
		return RayCastResult.new()

	var rayCastResult : RayCastResult = RayCastResult.new()
	rayCastResult.hitSuccess = true
	rayCastResult.collider = result.get("collider") as CollisionObject3D
	rayCastResult.hitPosition = result.get("position") as Vector3
	rayCastResult.hitNormal = result.get("normal")

	return rayCastResult
