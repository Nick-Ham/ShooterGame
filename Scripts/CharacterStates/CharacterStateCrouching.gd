extends CharacterState
class_name CharacterStateCrouching

@export_category("Config")
@export var stateOnJumpKey : String = "jumping"
@export var stateOnFallKey : String = "inAir"

var timeInAir : float = 0.0
const maxAirTime : float = 0.5

func update_physics(inDelta : float) -> void:
	super.update_physics(inDelta)

	if !getStateManager().getCharacter().is_on_floor():
		timeInAir += inDelta
	else:
		timeInAir = 0.0

	if timeInAir > maxAirTime:
		request_change_state.emit(stateOnFallKey)

func getStateKey() -> String:
	return "crouching"

func handleOnJumpChanged(inIsJumping : bool) -> void:
	if !inIsJumping:
		return

	var character : CharacterBody3D = getStateManager().getCharacter()
	if character.is_on_floor():
		character.velocity.y += jumpVelocity
		request_change_state.emit(stateOnJumpKey)
