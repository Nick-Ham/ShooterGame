extends Node
class_name CharacterStateManager

@export_category("DefaultStates")
@export var stateDefault : CharacterStateDefault

@onready var states : Array[CharacterState] = [
	stateDefault,
]

var character : CharacterBody3D = null
var controller : Controller = null
var lastState : CharacterState = null
var currentState : CharacterState = null
var nextState : CharacterState = null
var lastInputDirection : Vector2 = Vector2()

signal state_changed(lastState : CharacterState, newState : CharacterState)
signal head_punch_triggered(punch : Vector2)

const minSpeed : float = 0.08

const maxDelta : float = 0.1

func _ready() -> void:
	if !character:
		character = get_parent() as CharacterBody3D

	character.velocity = Vector3()

	assert(character, "CharacterStateManager only valid on a Character3D")

	controller = Controller.getController(character)
	if controller:
		bindToController(controller)

	fetchStates()

	Util.safeConnect(character.character_destroyed, on_character_destroyed)

	bindToStates()

	changeState(stateDefault)

func fetchStates() -> void:
	var children : Array[Node] = get_children()
	for child : Node in children:
		var state : CharacterState = child as CharacterState
		if !state:
			continue

		if states.has(state):
			continue

		states.append(state)

func on_character_destroyed(_inCharacter : Character) -> void:
	lastInputDirection = Vector2()

func forceChangeState(inStateKey : String) -> void:
	# might want to do something different later
	for state : CharacterState in states:
		if state.getStateKey() == inStateKey:
			changeState(state)
			break

func addController(inController : Controller) -> void:
	if !inController:
		return

	controller = inController
	bindToController(inController)

func bindToController(inController : Controller) -> void:
	Util.safeConnect(inController.input_direction_changed, on_input_direction_changed)
	Util.safeConnect(inController.jump_changed, on_jump_changed)
	Util.safeConnect(inController.crouch_changed, on_crouch_changed)

func on_input_direction_changed(inputDirection : Vector2) -> void:
	lastInputDirection = inputDirection

func on_jump_changed(inIsJumping : bool) -> void:
	currentState.handleOnJumpChanged(inIsJumping)

func on_crouch_changed(inIsCrouching : bool) -> void:
	currentState.handleOnCrouchChanged(inIsCrouching)

func _physics_process(delta: float) -> void:
	if Util.isValid(nextState):
		changeState(nextState)
		nextState = null

	currentState.update_physics(delta)

func getCharacterController() -> Controller:
	return Controller.getController(character)

func getCharacter() -> CharacterBody3D:
	return character

func getIsJumping() -> bool:
	if !controller:
		return false

	return controller.getIsJumping()

func getIsCrouching() -> bool:
	if !controller:
		return false

	return controller.getIsCrouching()

func getLastInputDirection() -> Vector2:
	return lastInputDirection

func changeState(inNewState : CharacterState) -> void:
	if currentState != null:
		currentState.stateExiting(inNewState)

	lastState = currentState

	currentState = inNewState
	currentState.stateEntering(lastState)

	state_changed.emit(lastState, currentState)

func on_request_change_state(inStateKey : String) -> void:
	if Util.isValid(nextState): # only allow one change of state per frame (signals are latent)
		return

	for state : CharacterState in states:
		if state.getStateKey() == inStateKey:
			nextState = state
			return

func bindToStates() -> void:
	for state : CharacterState in states:
		state.request_change_state.connect(on_request_change_state)

func getCurrentMaxSpeed() -> float:
	return currentState.maxSpeed

func getCurrentSpeed() -> float:
	var speed : float = character.velocity.length()
	if speed < minSpeed:
		return 0.0

	return speed

func getCurrentState() -> CharacterState:
	return currentState

func getMinimumSpeed() -> float:
	return minSpeed
