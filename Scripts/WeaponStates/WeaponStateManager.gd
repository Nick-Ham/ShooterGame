extends Node
class_name WeaponStateManager

@export_category("Config")
@export var loggerCategory : String = "Weapon:StateManager:State"
@export var weaponManager : WeaponManager

@export_category("States")
@export var stateDefault : WeaponState

@onready var states : Array[WeaponState] = [
	stateDefault
]

var currentState : WeaponState = null
var lastState : WeaponState = null
var controller : Controller = null
var character : CharacterBody3D = null

signal state_changed(lastState : WeaponState, newState : WeaponState)

func _ready() -> void:
	assert(weaponManager)

	if !character:
		character = get_parent() as CharacterBody3D

	controller = Controller.getController(character)
	if controller:
		bindToController(controller)

	DebugLogger.registerTrackedValue(loggerCategory)

	changeState(stateDefault)

func getIsShooting() -> bool:
	if !controller:
		return false

	return controller.getIsShooting()

func addController(inController : Controller) -> void:
	controller = inController
	bindToController(controller)

func bindToController(inController : Controller) -> void:
	Util.safeConnect(inController.shoot_changed, on_shoot_changed)

func on_shoot_changed(inIsShooting : bool) -> void:
	currentState.handleOnShootChanged(inIsShooting)

func changeState(inNewState : WeaponState) -> void:
	if currentState:
		currentState.stateExiting()

	lastState = currentState
	currentState = inNewState

	currentState.stateEntering()

	DebugLogger.updateTrackedValue(loggerCategory, currentState.getStateKey())
	state_changed.emit(lastState, currentState)

func getWeaponManager() -> WeaponManager:
	return weaponManager
