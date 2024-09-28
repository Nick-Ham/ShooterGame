extends Resource
class_name WeaponData

@export_category("WeaponInfo")
@export var weaponName : String = ""
@export var weaponScene : PackedScene = null

@export_category("WeaponStats")
@export var defaultDamage : float = 25.0
@export var firingDelay : float = 0.25
@export var magazineSize : int = 15

@export_category("GeneralWeaponRecoil")
@export var recoilLerpSpeed : float = 30.0
@export var recoilDecaySpeed : float = 15.0
## Only absolute value is used
@export var maxRecoilRotation : Vector3 = Vector3(10, 5, 5)
@export var maxRecoilTranslation : Vector3 = Vector3(0.05, 0.05, 0.3)

@export_category("PerShotRecoil")
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
