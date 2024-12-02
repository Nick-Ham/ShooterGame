extends WeaponState
class_name WeaponStateDefault

@export_category("Ref")
@export var shootSoundPlayer : AudioStreamPlayer3D
@export var damage : Damage

var readyToFire : bool = true

@onready var shootDelayTimer : Timer = Timer.new()

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

const showDebugImpacts : bool = true
const showDebugTrails : bool = true

var isCurrentlyShooting : bool = false
var bloomBuildup : float = 0.0

const minBloomDecay : float = 0.02

signal weapon_fired

func _ready() -> void:
	add_child(shootDelayTimer)
	shootDelayTimer.wait_time = getStateManager().getWeaponData().firingDelay #delayBetweenShots
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

	shootDelayTimer.start()

	EnvironmentEventBus.addEnvironmentSound(Character.getOwningCharacter(self))
	shootSoundPlayer.play()

	var equippedWeaponData : WeaponData = getStateManager().getWeaponData()

	var playerRecoilController : PlayerRecoilController = Util.getChildOfType(owningCharacter, PlayerRecoilController)
	if playerRecoilController:
		playerRecoilController.addRecoilRotationPunch(equippedWeaponData.getRandomRecoilRotation())
		playerRecoilController.addRecoilTranslationPunch(equippedWeaponData.getRandomRecoilTranslation())

	var controller : Controller = Util.getChildOfType(owningCharacter, Controller)
	assert(is_instance_valid(controller), "Shoot triggered on a weaponstate with no valid controller... how did you get here?")

	var aimCastResult : RayCastResult = controller.getAimCastResult(equippedWeaponData.getBloomRadiusAtTime(bloomBuildup))
	drawDebug(aimCastResult)
	
	if !aimCastResult.hitSuccess:
		return

	var colliderAsHitbox : Hitbox = aimCastResult.collider as Hitbox

	if colliderAsHitbox:
		handleHitEnemy(aimCastResult)
	else:
		handleHitEnvironment(aimCastResult)

	isCurrentlyShooting = true
	weapon_fired.emit()

func handleHitEnemy(hitResult : RayCastResult) -> void:
	damage.dealDamage(Character.getOwningCharacter(hitResult.collider))
	var hitBox : Hitbox = hitResult.collider as Hitbox
	if hitBox:
		hitBox.addImpact(hitResult.hitPosition, hitResult.hitNormal)

func handleOnShootChanged(inIsShooting : bool) -> void:
	if !inIsShooting:
		return

	shoot()

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
