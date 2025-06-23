extends Node
class_name SkittererAnimationController

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var modelAnimationTree : AnimationTree
@export var audioAnimationPlayer : AnimationPlayer

@export_category("Animation")
@export var animationSpeedTarget : float = 0.8
@export var directionLerpSpeed : float = 8.0

const moveBlendParam : String = "parameters/MoveDirection/blend_position"
const animationSpeedParam : String = "parameters/TimeScale/scale"

var animationDirection : Vector2 = Vector2()

@onready var stateManager : CharacterStateManager = Util.getChildOfType(get_parent(), CharacterStateManager)
@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)
@onready var skittererExplodeHandler : SkittererExplodeHandler

var owningCharacterDestroyed : bool = false

const deathAnimationKey : String = "OnDeath"
const audioAnimationWalkKey : String = "walking"

const explosionIntensity : float = 0.5

func _ready() -> void:
	assert(stateManager)
	assert(modelAnimationTree)
	assert(animationPlayer)
	assert(audioAnimationPlayer)

	audioAnimationPlayer.play(audioAnimationWalkKey)

	Util.safeConnect(owningCharacter.character_destroyed, on_character_destroyed)

func on_character_destroyed(_inCharacter : Character) -> void:
	owningCharacterDestroyed = true
	updateAnimationSpeed(1.0)
	audioAnimationPlayer.stop()

func explode() -> void:
	var environmentEffectManager : EnvironmentEffectManager = Game.getGame(get_tree()).getLevel().getEnvironmentalEffectManager()
	var explosion : Explosion = environmentEffectManager.addExplosion(owningCharacter.getHeadGlobalPosition())
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

	animationSpeed = inCharacterSpeed / animationSpeedTarget

	modelAnimationTree.set(animationSpeedParam, animationSpeed)
	audioAnimationPlayer.speed_scale = animationSpeed

func getForwardVector() -> Vector3:
	var characterForward : Vector3 = owningCharacter.global_basis * Vector3.BACK

	var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)
	if !weaponManager:
		return characterForward

	var weapon : Weapon = weaponManager.getEquippedWeapon()
	if !weapon:
		return characterForward

	return weapon.getBarrelEnd().global_basis * Vector3.BACK
