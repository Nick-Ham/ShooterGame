extends Controller
class_name AIController

@export_category("Ref")
@export var aimRayCast : RayCast3D
@export var btPlayer : BTPlayer

@export_category("Config")
@export var controlDirectionLerpSpeed : float = 3.0
@export var alwaysFaceTarget : bool = true

@export_category("Shooting")
@export_flags_3d_physics var shootingAimLayer : int = 9

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)
@onready var navigationController : NavigationController = Util.getChildOfType(owningCharacter, NavigationController)

const minRotationDistanceToNavigation : float = 3

func _ready() -> void:
	assert(aimRayCast)
	assert(targeter)
	assert(btPlayer)

	Util.safeConnect(owningCharacter.character_destroyed, on_character_destroyed)

func on_character_destroyed(_inCharacter : Character) -> void:
	cleanupAgent()
	queue_free()

func cleanupAgent() -> void:
	if Util.isValid(btPlayer):
		btPlayer.active = false
		btPlayer.queue_free()

	if Util.isValid(targeter):
		targeter.clearTarget()
		targeter.queue_free()

	if Util.isValid(navigationController):
		navigationController.queue_free()

	var shootController : AIShootController = Util.getChildOfType(owningCharacter, AIShootController)
	if Util.isValid(shootController):
		shootController.queue_free()

func _physics_process(delta: float) -> void:
	var interest : Targeter.TargetInterest = targeter.getInterest()
	if !interest:
		return

	var navigationPoint : Vector3 = navigationController.getNextNavigationPoint()
	var navigationFinalPosition : Vector3 = navigationController.getTargetPosition()

	if alwaysFaceTarget or owningCharacter.global_position.distance_squared_to(navigationFinalPosition) < minRotationDistanceToNavigation:
		owningCharacter.rotateCharacterToTarget(interest.interestPosition, delta)
	else:
		owningCharacter.rotateCharacterToTarget(navigationPoint, delta)


func setControlDirectionSmooth(inDirection : Vector2, inDelta : float) -> void:
	var newInputDirection : Vector2 = inDirection.normalized()
	inputDirection = lerp(inputDirection, newInputDirection, inDelta * controlDirectionLerpSpeed)
	input_direction_changed.emit(inputDirection)

func setControlDirection(inDirection : Vector2) -> void:
	inputDirection = inDirection.normalized()
	input_direction_changed.emit(inputDirection)

func shoot() -> void:
	shoot_changed.emit(true)
	await get_tree().physics_frame
	shoot_changed.emit(false)

func getAimDirection() -> Vector3:
	var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)
	assert(weaponManager, "WeaponManager required for AIController to correctly shoot a weapon")

	var currentWeapon : Weapon = weaponManager.getEquippedWeapon()
	if !currentWeapon:
		return Vector3()

	return currentWeapon.getBarrelEnd().basis * Vector3.FORWARD

func getAimCastResult(inBloom : float = 0.0) -> RayCastResult:
	var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)
	assert(weaponManager, "WeaponManager required for AIController to correctly shoot a weapon")

	var currentWeapon : Weapon = weaponManager.getEquippedWeapon()
	if !currentWeapon:
		return null

	return currentWeapon.getBarrelRayCastResult(inBloom)
