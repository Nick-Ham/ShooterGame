extends WeaponState
class_name WeaponStateDefault

@export_category("Config")
@export var onOutOfAmmoState : String = "outOfAmmo"

var readyToFire : bool = true

@onready var shootDelayTimer : Timer = Timer.new()

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var equippedWeaponData : WeaponData = getStateManager().getWeaponData()
@onready var weaponStateManager : WeaponStateManager = get_parent() as WeaponStateManager
@onready var weaponAnimationController : WeaponAnimationController = Util.getChildOfType(weaponStateManager.get_parent(), WeaponAnimationController)
@onready var damage : Damage = Damage.new()

const showDebugImpacts : bool = false
const showDebugTrails : bool = false

var isCurrentlyShooting : bool = false
var bloomBuildup : float = 0.0

const minBloomDecay : float = 0.02

signal weapon_fired

func _ready() -> void:
	add_child(shootDelayTimer)
	shootDelayTimer.wait_time = getStateManager().getWeaponData().firingDelay #delayBetweenShots
	Util.safeConnect(shootDelayTimer.timeout, on_shootDelayTimer_timeout)

	add_child(damage)
	damage.damage = equippedWeaponData.defaultDamage / equippedWeaponData.shotCount

func on_shootDelayTimer_timeout() -> void:
	readyToFire = true

	if !getStateManager().getIsShooting():
		isCurrentlyShooting = false
		return

	if !getStateManager().isCurrentState(self):
		return

	shoot()

func _process(delta: float) -> void:
	var weaponData : WeaponData = getStateManager().getWeaponData()
	bloomBuildup = lerpf(bloomBuildup, 0.0, clampf(weaponData.bloomDecaySpeed * delta, 0.0, 1.0))

	if bloomBuildup < minBloomDecay:
		bloomBuildup = 0.0

func getStateKey() -> String:
	return "default"

func shoot() -> void:
	if !readyToFire:
		return

	readyToFire = false

	if weaponStateManager.getCurrentAmmo() <= 0:
		request_change_state.emit(onOutOfAmmoState)
		return

	weaponStateManager.consumeAmmo(1)

	shootDelayTimer.start()

	EnvironmentEventBus.addEnvironmentSound(Character.getOwningCharacter(self))

	weaponAnimationController.playShoot()

	var playerRecoilController : PlayerRecoilController = Util.getChildOfType(owningCharacter, PlayerRecoilController)
	if playerRecoilController:
		playerRecoilController.addRecoilRotationPunch(equippedWeaponData.getRandomRecoilRotation())
		playerRecoilController.addRecoilTranslationPunch(equippedWeaponData.getRandomRecoilTranslation())

	var controller : Controller = Util.getChildOfType(owningCharacter, Controller)
	assert(is_instance_valid(controller), "Shoot triggered on a weaponstate with no valid controller... how did you get here?")

	var currentBloom : float = 1.0 if equippedWeaponData.useMaxBloom else bloomBuildup

	for currentShot : int in equippedWeaponData.shotCount:
		var newBloomRadius : float = equippedWeaponData.getBloomRadiusAtTime(currentBloom)
		var aimCastResult : RayCastResult = controller.getAimCastResult(newBloomRadius)
		drawDebug(aimCastResult)

		if !aimCastResult.hitSuccess:
			continue

		var colliderAsHitbox : Hitbox = aimCastResult.collider as Hitbox

		if colliderAsHitbox:
			handleHitEnemy(aimCastResult)
		else:
			handleHitEnvironment(aimCastResult)

	if !equippedWeaponData.useMaxBloom:
		bloomBuildup = clampf(bloomBuildup + equippedWeaponData.firingDelay, 0.0, 1.0)

	isCurrentlyShooting = true
	weapon_fired.emit()

	if weaponStateManager.getCurrentAmmo() <= 0:
		request_change_state.emit(onOutOfAmmoState)

func handleHitEnemy(hitResult : RayCastResult) -> void:
	damage.dealDamage(Character.getOwningCharacter(hitResult.collider), owningCharacter)
	var hitBox : Hitbox = hitResult.collider as Hitbox
	if hitBox:
		hitBox.addImpact(hitResult.hitPosition, hitResult.hitNormal)

func handleOnShootChanged(inIsShooting : bool) -> void:
	if !inIsShooting:
		return

	shoot()

func handleOnReloadChanged(inIsReloading : bool) -> void:
	if !inIsReloading:
		return

	var weaponReloadComponent : WeaponReloadComponent = Util.getChildOfType(weaponStateManager.get_parent(), WeaponReloadComponent)
	Util.safeConnect(weaponReloadComponent.reload_complete, on_reload_complete)
	weaponReloadComponent.reload()

	readyToFire = false

func on_reload_complete() -> void:
	readyToFire = true

func getCurrentBloomValue() -> float:
	return bloomBuildup

func handleHitEnvironment(rayCastResult : RayCastResult) -> void:
	var game : Game = get_tree().current_scene as Game
	var level : Level = game.getLevel()
	var environmentalEffectManager : EnvironmentEffectManager = level.getEnvironmentalEffectManager()

	environmentalEffectManager.addBulletImpact(rayCastResult.hitPosition, rayCastResult.hitNormal)

func drawDebug(rayCastResult : RayCastResult) -> void:
	if showDebugTrails:
		var rayEnd : Vector3 = rayCastResult.hitPosition if rayCastResult.hitSuccess else rayCastResult.rayEndpoint
		var originOffset : Vector3 = rayCastResult.rayOrigin - (rayCastResult.rayOrigin - rayEnd).normalized()
		DebugUtil.spawnDebugTrail([originOffset, rayEnd], get_tree())

	if showDebugImpacts and rayCastResult.hitSuccess:
		DebugUtil.spawnDebugSphere(rayCastResult.hitPosition, get_tree())
