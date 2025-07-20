extends Node
class_name CrouchController

@export_category("Ref")
@export var collisionShapeStanding : CollisionShape3D
@export var collisionShapeCrouching : CollisionShape3D
@export var standingNeckPosition : Marker3D
@export var crouchingNeckPosition : Marker3D
@export var neck : Neck

@export_category("Config")
@export var heightModCurve : Curve
@export var crouchHeightSpeed : float = 6.0

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var characterStateManager : CharacterStateManager = Util.getChildOfType(owningCharacter, CharacterStateManager)

@onready var crouchHeight : float = (standingNeckPosition.position.y - crouchingNeckPosition.position.y) / 2.0

func _ready() -> void:
	assert(collisionShapeStanding)
	assert(collisionShapeCrouching)
	assert(standingNeckPosition)
	assert(crouchingNeckPosition)
	assert(characterStateManager)

	Util.safeConnect(characterStateManager.state_changed, on_state_changed)

var heightTween : Tween
func tweenHeight(inIsCrouching : bool) -> void:
	if heightTween and heightTween.is_valid():
		heightTween.kill()

	isCrouching = inIsCrouching

	heightTween = create_tween()
	heightTween.set_process_mode(Tween.TweenProcessMode.TWEEN_PROCESS_PHYSICS)
	heightTween.tween_method(updateHeight, 0.0, 1.0, 1.0 / crouchHeightSpeed)

	lastDelta = 0.0

var isCrouching : bool = false
var lastDelta : float = 0.0
func updateHeight(inDelta : float) -> void:
	var currentCurveSample : float = heightModCurve.sample_baked(inDelta)
	var newHeightDelta : float = currentCurveSample - lastDelta
	lastDelta = currentCurveSample

	var addedHeight : float = newHeightDelta * crouchHeight
	if !isCrouching:
		addedHeight *= -1.0

	owningCharacter.global_position.y += addedHeight

func on_state_changed(lastState : CharacterState, newState : CharacterState) -> void:
	var isCrouchingState : bool = newState.getIsCrouchingState()

	collisionShapeCrouching.disabled = !isCrouchingState
	collisionShapeStanding.disabled = isCrouchingState

	if Util.isValid(lastState) and lastState.getIsCrouchingState() == isCrouchingState:
		return

	tweenHeight(isCrouchingState)
