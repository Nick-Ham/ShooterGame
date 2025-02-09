extends CharacterState
class_name CharacterStateJumping

@export_category("Config")
@export var postJumpState : String = "inAir"
@export var jumpBufferDuration : float = 0.2

func getStateKey() -> String:
	return "jumping"

func stateEntering() -> void:
	var bufferTimer : SceneTreeTimer = get_tree().create_timer(jumpBufferDuration, false)
	await bufferTimer.timeout
	request_change_state.emit(postJumpState)
