extends CharacterState
class_name CharacterStateJumping

@export_category("State")
@export var stateKey : String = CharacterStateLibrary.jumpingStateKey

@export_category("Config")
@export var postJumpState : String = CharacterStateLibrary.inAirStateKey
@export var onCrouchStateKey : String = CharacterStateLibrary.inAirCrouchingStateKey
@export var jumpBufferDuration : float = 0.2
@export var isCrouchedState : bool = false

@onready var jumpTimer : Timer = Timer.new()

func _ready() -> void:
	super._ready()

	jumpTimer.autostart = false
	jumpTimer.wait_time = jumpBufferDuration
	Util.safeConnect(jumpTimer.timeout, on_jumpTimer_timeout)
	add_child(jumpTimer)

func getIsCrouchingState() -> bool:
	return isCrouchedState

func on_jumpTimer_timeout() -> void:
	if getStateManager().getCurrentState().getStateKey() != getStateKey():
		return

	request_change_state.emit(postJumpState)

func getStateKey() -> String:
	return stateKey

func stateEntering(_inLastState : CharacterState) -> void:
	jumpTimer.start(jumpBufferDuration)

func crouchMatchesState(inIsCrouching : bool) -> bool:
	return inIsCrouching == getIsCrouchingState()

func handleOnCrouchChanged(inIsCrouching : bool) -> void:
	if crouchMatchesState(inIsCrouching):
		return

	request_change_state.emit(onCrouchStateKey)

func stateExiting(_inNewState : CharacterState) -> void:
	jumpTimer.stop()
