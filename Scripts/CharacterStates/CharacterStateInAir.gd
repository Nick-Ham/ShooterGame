extends CharacterState
class_name CharacterStateInAir

@export_category("Config")
@export var landingStateKey : String = CharacterStateLibrary.defaultStateKey
@export var onCrouchStateKey : String = CharacterStateLibrary.inAirCrouchingStateKey

var lastVelocity : Vector3 = Vector3()

func getStateKey() -> String:
	return CharacterStateLibrary.inAirStateKey

func update_physics(inDelta : float) -> void:
	var character : Character = getStateManager().getCharacter()
	var velocity : Vector3 = getStateManager().getCharacter().velocity

	lastVelocity = velocity
	super.update_physics(inDelta)
	character.velocity += getFriction(velocity, inDelta)

	if getStateManager().getCharacter().is_on_floor():
		request_change_state.emit(landingStateKey)
		return

func getLastVelocity() -> Vector3:
	return lastVelocity

func handleOnCrouchChanged(inIsCrouching : bool) -> void:
	if !inIsCrouching:
		return

	request_change_state.emit(onCrouchStateKey)
