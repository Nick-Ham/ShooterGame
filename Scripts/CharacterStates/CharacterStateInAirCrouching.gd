extends CharacterState
class_name CharacterStateInAirCrouching

@export_category("Config")
@export var landingStateKey : String = CharacterStateLibrary.crouchingStateKey
@export var stateOnCrouchEndInAirKey : String = CharacterStateLibrary.inAirStateKey
@export var stateOnCrouchEndOnFloorKey : String = CharacterStateLibrary.defaultStateKey

var lastVelocity : Vector3 = Vector3()

func getStateKey() -> String:
	return CharacterStateLibrary.inAirCrouchingStateKey

func getIsCrouchingState() -> bool:
	return true

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
	if inIsCrouching:
		return

	if getStateManager().getCharacter().is_on_floor():
		request_change_state.emit(stateOnCrouchEndOnFloorKey)
		return
	
	request_change_state.emit(stateOnCrouchEndInAirKey)
