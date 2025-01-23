extends Node3D
class_name Weapon

@export_category("Ref")
@export var weaponBarrelEnd : Marker3D

@onready var weaponStateManager : WeaponStateManager = Util.getChildOfType(self, WeaponStateManager)

var currentWeaponData : WeaponData = null

signal ammo_updated(newAmmo : int)
signal weapon_unequipped

func _ready() -> void:
	assert(weaponBarrelEnd)

	Util.safeConnect(weaponStateManager.ammo_updated, on_ammo_updated)

func on_ammo_updated(inNewAmmo : int) -> void:
	ammo_updated.emit(inNewAmmo)

func getBarrelEnd() -> Marker3D:
	return weaponBarrelEnd

func unequip() -> void:
	weapon_unequipped.emit()

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

func getCurrentAmmo() -> int:
	return weaponStateManager.getCurrentAmmo()
