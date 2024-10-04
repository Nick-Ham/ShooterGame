extends WeaponState
class_name WeaponStateDefault

@export var shootSoundPlayer : AudioStreamPlayer3D
@export var shootRecoilPunch : Punch

var readyToFire : bool = true

@onready var shootDelayTimer : Timer = Timer.new()

const showDebugImpacts : bool = false
const showDebugTrails : bool = false

var isCurrentlyShooting : bool = false
var bloomBuildup : float = 0.0

const minBloomDecay : float = 0.02

signal weapon_fired

func _ready() -> void:
	add_child(shootDelayTimer)
	shootDelayTimer.wait_time = getStateManager().getWeaponManager().getEquippedWeaponData().firingDelay #delayBetweenShots
	Util.safeConnect(shootDelayTimer.timeout, on_shootDelayTimer_timeout)

func on_shootDelayTimer_timeout() -> void:
	readyToFire = true

	if !getStateManager().getIsShooting():
		isCurrentlyShooting = false
		return

	shoot()

func _process(delta: float) -> void:
	if isCurrentlyShooting:
		bloomBuildup = clampf(bloomBuildup + delta, 0.0, 1.0)
	else:
		var weaponData : WeaponData = getStateManager().getWeaponManager().getEquippedWeaponData()
		bloomBuildup = lerpf(bloomBuildup, 0.0, clampf(weaponData.bloomDecaySpeed * delta, 0.0, 1.0))

		if bloomBuildup < minBloomDecay:
			bloomBuildup = 0.0

func getStateKey() -> String:
	return "default"

func shoot() -> void:
	if !readyToFire:
		return
	readyToFire = false

	shootDelayTimer.start()
	shootSoundPlayer.play()

	var equippedWeaponData : WeaponData = getStateManager().getWeaponManager().getEquippedWeaponData()

	shootRecoilPunch.addRotationPunch(equippedWeaponData.getRandomRecoilRotation())
	shootRecoilPunch.addTranslationPunch(equippedWeaponData.getRandomRecoilTranslation())

	var controller : Controller = Controller.getController(getStateManager().get_parent())
	assert(is_instance_valid(controller), "Shoot triggered on a weaponstate with no valid controller... how did you get here?")

	var aimCastResult : RayCastResult = controller.getAimCastResult(equippedWeaponData.getBloomRadiusAtTime(bloomBuildup))
	if !aimCastResult.hitSuccess:
		return

	var game : Game = get_tree().current_scene as Game
	var level : Level = game.getLevel()
	var environmentalEffectManager : EnvironmentEffectManager = level.getEnvironmentalEffectManager()

	environmentalEffectManager.addBulletImpact(aimCastResult.hitPosition, aimCastResult.hitNormal)

	if showDebugImpacts:
		PrototypingUtil.spawnDebugSphere(aimCastResult.hitPosition)

	if showDebugTrails:
		var originOffset : Vector3 = aimCastResult.rayOrigin - (aimCastResult.rayOrigin - aimCastResult.hitPosition).normalized()
		PrototypingUtil.spawnDebugTrail([originOffset, aimCastResult.hitPosition])

	isCurrentlyShooting = true
	weapon_fired.emit()

func handleOnShootChanged(inIsShooting : bool) -> void:
	if !inIsShooting:
		return

	shoot()

func getCurrentBloomValue() -> float:
	return bloomBuildup
