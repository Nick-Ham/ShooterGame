extends Node
class_name RobotWalkerAnimationController

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var modelAnimationTree : AnimationTree
@export var aimPivot : Node3D

@export_category("Config")
@export var lookSpeed : float = 10.0
@export var maxYawAngle : float = PI/2.0 - .1
@export var maxPitchAngle : float = PI/12.0
@export var targetTrackPitchRange : Vector2 = Vector2(-PI/12.0, PI/6.0)

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
	environmentEffectManager.addExplosion(owningCharacter.getHeadGlobalPosition())

func _physics_process(delta: float) -> void:
	if owningCharacterDestroyed:
		aimTowardsForwards(delta)
		modelAnimationTree.set(moveBlendParam, Vector2())
		return

	var moveDirection : Vector3 = owningCharacter.velocity.normalized() * owningCharacter.global_basis
	var moveDirectionPlanar : Vector2 = Vector2(moveDirection.x, moveDirection.z)

	animationDirection = lerp(animationDirection, moveDirectionPlanar, delta * directionLerpSpeed)

	modelAnimationTree.set(moveBlendParam, animationDirection)
	updateAnimationSpeed(owningCharacter.velocity.length())

	updateLookDirection(delta)

func updateLookDirection(inDelta : float) -> void:
	var currentInterest : Targeter.TargetInterest = targeter.getInterest()
	if !currentInterest:
		aimTowardsForwards(inDelta)
		return

	var targetLookPosition : Vector3 = currentInterest.interestPosition
	var aimDirection : Vector3 = aimPivot.global_position - targetLookPosition
	var forwardRelative : Vector3 = owningCharacter.global_basis * Vector3.BACK

	var angleDifference : float = abs(aimDirection.normalized().angle_to(forwardRelative.normalized()))
	
	# This angle 'softening' prevents axis flipping during the lerpToVector method.
	# Theoretically shouldnt happen, but im not a mathologist
	if (angleDifference > PI/2.0):
		aimDirection = (forwardRelative * 1.0 + aimDirection * 0.1).normalized()

	MathUtil.lerpToVector(aimPivot, Vector3.UP, aimDirection, lookSpeed * inDelta)
	aimPivot.rotation.y = clampf(aimPivot.rotation.y, -abs(maxYawAngle), abs(maxYawAngle))
	aimPivot.rotation.x = clampf(aimPivot.rotation.x, -abs(maxPitchAngle), abs(maxPitchAngle))

func updateAnimationSpeed(inCharacterSpeed : float) -> void:
	var animationSpeed : float = 1.0

	if inCharacterSpeed > animationSpeedTarget:
		animationSpeed = inCharacterSpeed / animationSpeedTarget

	modelAnimationTree.set(animationSpeedParam, animationSpeed)

func aimTowardsForwards(inDelta : float) -> void:
	aimPivot.set_basis(aimPivot.basis.slerp(Basis.IDENTITY, lookSpeed * inDelta))
