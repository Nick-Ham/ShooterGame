extends CharacterStateDefault
class_name CharacterStateCrouching

@export_category("Config")
@export var stateOnCrouchEndKey : String = CharacterStateLibrary.defaultStateKey
@export var stateOnCrouchEndInAirKey : String = CharacterStateLibrary.inAirStateKey

func getStateKey() -> String:
	return CharacterStateLibrary.crouchingStateKey

func getIsCrouchingState() -> bool:
	return true

func handleOnJumpChanged(inIsJumping : bool) -> void:
	if !inIsJumping:
		return

	var character : CharacterBody3D = getStateManager().getCharacter()
	if character.is_on_floor():
		character.velocity.y += jumpVelocity
		request_change_state.emit(stateOnJumpKey)

func handleOnCrouchChanged(inIsCrouching : bool) -> void:
	if inIsCrouching:
		return
	
	var character : CharacterBody3D = getStateManager().getCharacter()
	if character.is_on_floor():
		request_change_state.emit(stateOnCrouchEndKey)
		return
	
	request_change_state.emit(stateOnCrouchEndInAirKey)
	
