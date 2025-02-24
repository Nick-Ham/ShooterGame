extends Controller
class_name AIController

@export_category("Ref")
@export var aimRayCast : RayCast3D

@export_category("Config")
@export var controlDirectionLerpSpeed : float = 3.0

@export_category("Shooting")
@export_flags_3d_physics var shootingAimLayer : int = 9

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)

func _ready() -> void:
	assert(aimRayCast)

	Util.safeConnect(owningCharacter.character_destroyed, on_character_destroyed)

func on_character_destroyed(_inCharacter : Character) -> void:
	var behaviorTree : BehaviorTree = Util.getChildOfType(owningCharacter, BehaviorTree)
	if is_instance_valid(behaviorTree):
		behaviorTree.queue_free()

	queue_free()

func _physics_process(delta: float) -> void:
	var interest : Targeter.TargetInterest = targeter.getInterest()
	if !interest:
		return

	owningCharacter.rotateCharacterToTarget(interest.interestPosition, delta)

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

func getAimCastResult(inBloom : float = 0.0) -> RayCastResult:
	var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)
	assert(weaponManager, "WeaponManager required for AIController to correctly shoot a weapon")

	var currentWeapon : Weapon = weaponManager.getEquippedWeapon()
	if !currentWeapon:
		return null

	return currentWeapon.getBarrelRayCastResult(inBloom)
