extends WeaponState
class_name WeaponStateDefaultProjectile

@export_category("Ref")
@export var barrelEnd : Marker3D
@export var shootSoundPlayer : AudioStreamPlayer3D
@export var shootRecoilPunch : Punch
@export var damage : Damage

var readyToFire : bool = true

@onready var shootDelayTimer : Timer = Timer.new()

var isCurrentlyShooting : bool = false
var bloomBuildup : float = 0.0

const minBloomDecay : float = 0.02

const projectileSpawnDistance : float = 0.5

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

	EnvironmentEventBus.addEnvironmentSound(Character.getOwningCharacter(self))
	shootSoundPlayer.play()

	var equippedWeaponData : WeaponData = getStateManager().getWeaponManager().getEquippedWeaponData()

	if is_instance_valid(shootRecoilPunch):
		shootRecoilPunch.addRotationPunch(equippedWeaponData.getRandomRecoilRotation())
		shootRecoilPunch.addTranslationPunch(equippedWeaponData.getRandomRecoilTranslation())

	var controller : Controller = Controller.getController(getStateManager().get_parent())
	assert(is_instance_valid(controller), "Shoot triggered on a weaponstate with no valid controller... how did you get here?")

	var projectileInstance : Projectile = equippedWeaponData.projectileScene.instantiate()

	var game : Game = Game.getGame(get_tree())
	var level : Level = game.getLevel()

	level.add_child(projectileInstance)

	projectileInstance.global_position = barrelEnd.global_position
	setProjectileBasis(projectileInstance, controller, 1.0)

	var bloom : float = equippedWeaponData.getBloomRadiusAtTime(getCurrentBloomValue())

	var pitchAngle : float = randf_range(-1.0, 1.0) * 2 * PI * bloom
	var yawAngle : float = randf_range(-1.0, 1.0) * 2 * PI * bloom

	projectileInstance.rotate(Vector3.RIGHT, pitchAngle)
	projectileInstance.rotate(Vector3.UP, yawAngle)

	isCurrentlyShooting = true
	weapon_fired.emit()

func setProjectileBasis(inProjectile : Projectile, inController : Controller, inTrackingStrength : float) -> void:
	var aiController : AIController = inController as AIController
	if aiController:
		var targeter : Targeter = Util.getChildOfType(inController.get_parent(), Targeter)
		if !targeter:
			push_error("Weapon controller by AIController requires a targeter")
			return

		if !targeter.getTarget():
			inProjectile.global_basis = barrelEnd.global_basis

		var trackedBody : CharacterBody3D = targeter.getTarget() as CharacterBody3D
		var addedTrackingValue : Vector3 = Vector3()

		var interest : Targeter.TargetInterest = targeter.getInterest()
		if !interest:
			push_error("AI shoot triggered with no interest position")
			return

		var targetHeadPosition : Vector3 = interest.interestPosition

		if trackedBody:
			var distanceToTarget : float = inProjectile.global_position.distance_to(targetHeadPosition)

			var timeToTarget : float = distanceToTarget / inProjectile.speed

			addedTrackingValue = trackedBody.velocity * inTrackingStrength * timeToTarget

		var targetPosition : Vector3 = targetHeadPosition + addedTrackingValue
		var vectorTo : Vector3 = inProjectile.global_position - targetPosition

		MathUtil.lerpToVector(inProjectile, Vector3.UP, -vectorTo.normalized(), 1.0)

	# player rotational functionality

	return

func handleOnShootChanged(inIsShooting : bool) -> void:
	if !inIsShooting:
		return

	shoot()

func getCurrentBloomValue() -> float:
	return bloomBuildup
