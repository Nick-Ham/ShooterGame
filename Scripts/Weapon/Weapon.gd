extends Node3D
class_name Weapon

@export_category("Ref")
@export var weaponBarrelEnd : Marker3D
#@export var weaponEndRayCast : RayCast3D

@onready var weaponStateManager : WeaponStateManager = Util.getChildOfType(self, WeaponStateManager)

var currentWeaponData : WeaponData = null

func _ready() -> void:
	assert(weaponBarrelEnd)
	#assert(weaponEndRayCast)

func getBarrelEnd() -> Marker3D:
	return weaponBarrelEnd

func readyWeapon() -> void:
	weaponStateManager.readyWeapon()

func injectWeaponData(inWeaponData : WeaponData) -> void:
	currentWeaponData = inWeaponData

func getWeaponData() -> WeaponData:
	return currentWeaponData

func getCurrentBloomValue() -> float:
	return weaponStateManager.getCurrentBloomValue()

func getBarrelRayCastResult(inBloom : float) -> RayCastResult:
	var worldReference : World3D = get_world_3d()
	var spaceState : PhysicsDirectSpaceState3D = worldReference.direct_space_state
	
	var origin : Vector3 = getBarrelEnd().global_position
	
	var rayVector : Vector3 = WeaponUtil.getBloomedForward(inBloom) * WeaponUtil.maxHitScanDistance
	rayVector = global_basis * rayVector
	
	var endpoint : Vector3 = rayVector + origin

	var rayQuery : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, endpoint, WeaponUtil.weaponHitScanPhysicsLayer)
	rayQuery.collide_with_bodies = true
	rayQuery.collide_with_areas = true

	var character : Character = Character.getOwningCharacter(self)
	var hitboxes : Array[Hitbox] = Hitbox.getHitboxes(character)
	rayQuery.exclude = Hitbox.getHitboxRIDs(hitboxes)

	var result : Dictionary = spaceState.intersect_ray(rayQuery)

	var rayCastResult : RayCastResult = RayCastResult.new()
	rayCastResult.rayOrigin = origin
	rayCastResult.rayEndpoint = endpoint

	if result.is_empty():
		rayCastResult.hitSuccess = false
		return rayCastResult

	rayCastResult.hitSuccess = true
	rayCastResult.collider = result.get("collider") as CollisionObject3D
	rayCastResult.hitPosition = result.get("position") as Vector3
	rayCastResult.hitNormal = result.get("normal") as Vector3

	return rayCastResult
