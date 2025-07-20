extends CharacterStateDefault
class_name CharacterStateCrouching

@export_category("Ref")
@export var standingShapeCast : ShapeCast3D

@export_category("Config")
@export var stateOnCrouchEndKey : String = CharacterStateLibrary.defaultStateKey
@export var stateOnCrouchEndInAirKey : String = CharacterStateLibrary.inAirStateKey
@export var stateOnCrouchFallKey : String = CharacterStateLibrary.inAirCrouchingStateKey

func _ready() -> void:
	assert(standingShapeCast)

	super._ready()

func getStateKey() -> String:
	return CharacterStateLibrary.crouchingStateKey

func getIsCrouchingState() -> bool:
	return true

func onCoyoteTimeEnd() -> void:
	request_change_state.emit(stateOnCrouchFallKey)

func update_physics(inDelta : float) -> void:
	super.update_physics(inDelta)

	if !getStateManager().getIsCrouching() and canStandUp():
		request_change_state.emit(stateOnCrouchEndKey)

func canStandUp() -> bool:
	return !standingShapeCast.is_colliding()

func handleOnJumpChanged(inIsJumping : bool) -> void:
	if !inIsJumping:
		return

	var character : CharacterBody3D = getStateManager().getCharacter()
	if character.is_on_floor():
		character.velocity.y += jumpVelocity
		request_change_state.emit(stateOnJumpKey)

func handleOnCrouchChanged(inIsCrouching : bool) -> void:
	if inIsCrouching || !canStandUp():
		return

	var character : CharacterBody3D = getStateManager().getCharacter()
	if character.is_on_floor():
		request_change_state.emit(stateOnCrouchEndKey)
		return

	request_change_state.emit(stateOnCrouchEndInAirKey)
