extends CharacterState
class_name CharacterStateJumping

@export_category("Config")
@export var postJumpState : String = CharacterStateLibrary.inAirStateKey
@export var onCrouchStateKey : String = CharacterStateLibrary.inAirCrouchingStateKey
@export var jumpBufferDuration : float = 0.2
@export var onCrouchHeightBump : float = (1.5 - 1.0) / 2.0 # standing neck height vs crouching neck height, halved

@onready var jumpTimer : Timer = Timer.new()

func _ready() -> void:
	super._ready()
	
	jumpTimer.autostart = false
	jumpTimer.wait_time = jumpBufferDuration
	Util.safeConnect(jumpTimer.timeout, on_jumpTimer_timeout)
	add_child(jumpTimer)

func on_jumpTimer_timeout() -> void:
	request_change_state.emit(postJumpState)

func getStateKey() -> String:
	return CharacterStateLibrary.jumpingStateKey

func stateEntering(_inLastState : CharacterState) -> void:
	jumpTimer.start(jumpBufferDuration)

func handleOnCrouchChanged(inIsCrouching : bool) -> void:
	if !inIsCrouching:
		return
	
	request_change_state.emit(onCrouchStateKey)

func stateExiting(inNewState : CharacterState) -> void:
	jumpTimer.stop()
	
	if inNewState.getStateKey() != onCrouchStateKey:
		return
	
	getStateManager().getCharacter().global_position.y += onCrouchHeightBump
