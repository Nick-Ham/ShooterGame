extends Node
class_name SmallRobotAnimationController

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var modelAnimationTree : AnimationTree

@export_category("Animation")
@export var animationSpeedTarget : float = 2.5
@export var directionLerpSpeed : float = 8.0

const moveBlendParam : String = "parameters/MoveDirection/blend_position"
const animationSpeedParam : String = "parameters/TimeScale/scale"

var animationDirection : Vector2 = Vector2()

@onready var stateManager : CharacterStateManager = Util.getChildOfType(get_parent(), CharacterStateManager)
@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)

var owningCharacterDestroyed : bool = false

const deathAnimationKey : String = "OnDeath"

const explosionIntensity : float = 0.5

func _ready() -> void:
	assert(stateManager)
	assert(modelAnimationTree)
	assert(animationPlayer)

	Util.safeConnect(owningCharacter.character_destroyed, on_character_destroyed)

func on_character_destroyed(_inCharacter : Character) -> void:
	owningCharacterDestroyed = true
	updateAnimationSpeed(1.0)
	animationPlayer.play(deathAnimationKey)

func explode() -> void:
	var environmentEffectManager : EnvironmentEffectManager = Game.getGame(get_tree()).getLevel().getEnvironmentalEffectManager()
	var explosion : ExplosionEffect = environmentEffectManager.addExplosion(owningCharacter.getHeadGlobalPosition())
	explosion.updateIntensity(explosionIntensity)

func _physics_process(delta: float) -> void:
	if owningCharacterDestroyed:
		modelAnimationTree.set(moveBlendParam, Vector2())
		return

	var moveDirection : Vector3 = owningCharacter.velocity.normalized() * owningCharacter.global_basis
	var moveDirectionPlanar : Vector2 = Vector2(moveDirection.x, moveDirection.z)

	animationDirection = lerp(animationDirection, moveDirectionPlanar, delta * directionLerpSpeed)

	modelAnimationTree.set(moveBlendParam, animationDirection)
	updateAnimationSpeed(owningCharacter.velocity.length())

func updateAnimationSpeed(inCharacterSpeed : float) -> void:
	var animationSpeed : float = 1.0

	if inCharacterSpeed > animationSpeedTarget:
		animationSpeed = inCharacterSpeed / animationSpeedTarget

	modelAnimationTree.set(animationSpeedParam, animationSpeed)

func getForwardVector() -> Vector3:
	var characterForward : Vector3 = owningCharacter.global_basis * Vector3.BACK

	var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)
	if !weaponManager:
		return characterForward

	var weapon : Weapon = weaponManager.getEquippedWeapon()
	if !weapon:
		return characterForward

	return weapon.getBarrelEnd().global_basis * Vector3.BACK