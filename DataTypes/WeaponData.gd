extends Resource
class_name WeaponData

@export_category("WeaponInfo")
@export var weaponName : String = ""
@export var weaponScene : PackedScene = null

@export_category("WeaponModel")
@export var weaponModelScene : PackedScene = null

@export_category("AmmoInfo")
@export var weaponAmmoItem : QuantityItem = null
@export var maxAmmoStorage : int = 0

@export_category("WeaponTypeConfig")
@export var isAutomatic : bool = false
@export var useMaxBloom : bool = false
@export var shotCount : int = 1
@export var isProjectile : bool = false
@export var projectileScene : PackedScene

@export_category("WeaponStats")
@export var defaultDamage : float = 25.0
@export var firingDelay : float = 0.1
@export var magazineSize : int = 15
@export var baseBloomRadius : float = 0.0
@export var maxBloomRadius : float = 0.003
@export var bloomDecaySpeed : float = 3.0
## Bloom curve x-axis is time sustaining fire. y-axis is multiplier against bloom radius.
@export var bloomCurve : Curve = Curve.new()

@export_category("PerShotRecoil")
@export_group("CameraRecoil")
@export var useCameraRecoil : bool = false
@export var cameraRecoil : Vector3 = Vector3(12.0, 0.0, 1.75)
@export_group("Rotation")
@export var recoilRotationPitchRange : Vector2 = Vector2(2.5, 10.0)
@export var recoilRotationYawRange : Vector2 = Vector2(-3.0, 3.0)
@export var recoilRotationRollRange : Vector2 = Vector2(-0.2, 0.2)
@export_group("Translation")
@export var recoilTranslationForwardRange : Vector2 = Vector2(0.05, 0.1)
@export var recoilTranslationRightRange : Vector2 = Vector2(-0.01, 0.01)
@export var recoilTranslationUpRange : Vector2 = Vector2(0, 0)

static func validateWeapon(inWeaponData : WeaponData) -> bool:
	if inWeaponData == null:
		return false

	if !inWeaponData.weaponModelScene:
		return false

	if !inWeaponData.weaponScene:
		return false

	return true

func getRandomRecoilRotation() -> Vector3:
	var recoilRotationPitch : float =  RandUtil.randf_range_vector2(recoilRotationPitchRange)
	var recoilRotationYaw : float = RandUtil.randf_range_vector2(recoilRotationYawRange)
	var recoilRotationRoll : float = RandUtil.randf_range_vector2(recoilRotationRollRange)

	return Vector3(recoilRotationPitch, recoilRotationYaw, recoilRotationRoll)

func getRandomRecoilTranslation() -> Vector3:
	var recoilTranslationForward : float = RandUtil.randf_range_vector2(recoilTranslationForwardRange)
	var recoilTranslationRight : float = RandUtil.randf_range_vector2(recoilTranslationRightRange)
	var recoilTranslationUp : float = RandUtil.randf_range_vector2(recoilTranslationUpRange)

	return Vector3(recoilTranslationRight, recoilTranslationUp, recoilTranslationForward)

func getBloomRadiusAtTime(inTime : float) -> float:
	return remap(bloomCurve.sample(clampf(inTime, 0.0, 1.0)), 0.0, 1.0, baseBloomRadius, maxBloomRadius)
