extends ControllableCamera
class_name FPSView

@export_category("Config")
@export var subViewport : SubViewport
@export var viewportCamera : Camera3D
@export var aimRayCast : RayCast3D

@export_category("CameraAimRayConfig")
@export_flags_3d_physics var cameraRayLayer : int = 0

const cameraRayMax : float = 1000.0

func _ready() -> void:
	super._ready()

	assert(subViewport, "Must assign subviewport in order to function. " + self.name)
	assert(viewportCamera, "Must assign viewportCamera in order to function. " + self.name)
	assert(aimRayCast)

	aimRayCast.target_position = Vector3(0, 0, -cameraRayMax)

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

func getCameraCastResult(inBloom : float = 0.0) -> RayCastResult:
	var worldReference : World3D = get_world_3d()
	var spaceState : PhysicsDirectSpaceState3D = worldReference.direct_space_state

	var screenCenter : Vector2 = get_viewport().size / 2.0
	var origin : Vector3 = project_ray_origin(screenCenter)
	var normalVector : Vector3 = project_ray_normal(screenCenter)# * cameraRayMax

	var pitchAngle : float = randf_range(-1.0, 1.0) * 2 * PI * inBloom
	var yawAngle : float = randf_range(-1.0, 1.0) * 2 * PI * inBloom

	normalVector = normalVector.rotated(Vector3.UP, pitchAngle)
	normalVector = normalVector.rotated(Vector3.RIGHT, yawAngle)

	var endpoint : Vector3 = normalVector * cameraRayMax + origin

	var rayQuery : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, endpoint, cameraRayLayer)
	rayQuery.collide_with_bodies = true
	rayQuery.collide_with_areas = true

	var result : Dictionary = spaceState.intersect_ray(rayQuery)

	if result.is_empty():
		return RayCastResult.new()

	var rayCastResult : RayCastResult = RayCastResult.new()
	rayCastResult.hitSuccess = true
	rayCastResult.collider = result.get("collider") as CollisionObject3D
	rayCastResult.hitPosition = result.get("position") as Vector3
	rayCastResult.hitNormal = result.get("normal")
	rayCastResult.rayOrigin = origin

	return rayCastResult
