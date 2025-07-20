extends Node3D
class_name Neck

@export_category("Ref")
@export var standingNeckPosition : Marker3D
@export var crouchingNeckPosition : Marker3D
@export var characterStateManager : CharacterStateManager
@export_category("Config")
@export var cameraUpdateCurve : Curve
@export var updateSpeed : float = 6.0

@onready var targetPosition : Vector3 = standingNeckPosition.global_position

const positionKey : String = "position"

var currentTween : Tween = null
var isCrouching : bool = false

func _ready() -> void:
	assert(characterStateManager)

	Util.safeConnect(characterStateManager.state_changed, on_state_changed)

func on_state_changed(_inLastState : CharacterState, inNewState : CharacterState) -> void:
	setCrouched(inNewState.getIsCrouchingState())

func setCrouched(inIsCrouching : bool) -> void:
	if isCrouching == inIsCrouching:
		return

	if currentTween and currentTween.is_valid():
		currentTween.kill()

	isCrouching = inIsCrouching

	currentTween = create_tween()
	currentTween.set_process_mode(Tween.TweenProcessMode.TWEEN_PROCESS_PHYSICS)
	currentTween.tween_method(updateNeckPosition, 0.0, 1.0, 1.0 / updateSpeed)

func updateNeckPosition(inDelta : float) -> void:
	var samplePosition : float = cameraUpdateCurve.sample_baked(inDelta)
	var newWeight : float = inDelta #samplePosition if isCrouching else 1.0 - samplePosition

	var toPosition : Vector3 = crouchingNeckPosition.position if isCrouching else standingNeckPosition.position
	var newPosition : Vector3 = lerp(position, toPosition, newWeight)

	position = newPosition
