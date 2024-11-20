extends Node
class_name WeaponStateManager

@export_category("Config")
@export var loggingEnabled : bool = false
@export var loggerCategory : String = "Weapon:StateManager:State"

@export_category("States")
@export var stateDefault : WeaponState

@onready var states : Array[WeaponState] = [
	stateDefault
]

var currentState : WeaponState = null
var lastState : WeaponState = null
var controller : Controller = null

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

signal state_changed(lastState : WeaponState, newState : WeaponState)
signal weapon_fired

func _ready() -> void:
	controller = Controller.getController(owningCharacter)
	if controller:
		bindToController(controller)

	if loggingEnabled:
		DebugLogger.registerTrackedValue(loggerCategory)

func readyWeapon() -> void:
	changeState(stateDefault)

func getIsShooting() -> bool:
	if !controller:
		return false

	return controller.getIsShooting()

func getWeaponData() -> WeaponData:
	var weapon : Weapon = get_parent() as Weapon
	return weapon.getWeaponData()

func addController(inController : Controller) -> void:
	controller = inController
	bindToController(controller)

func bindToController(inController : Controller) -> void:
	Util.safeConnect(inController.shoot_changed, on_shoot_changed)

func on_shoot_changed(inIsShooting : bool) -> void:
	if currentState:
		currentState.handleOnShootChanged(inIsShooting)

func changeState(inNewState : WeaponState) -> void:
	if currentState:
		currentState.stateExiting()

	lastState = currentState
	currentState = inNewState

	currentState.stateEntering()

	if loggingEnabled:
		DebugLogger.updateTrackedValue(loggerCategory, currentState.getStateKey())

	if controller and controller.getIsShooting():
		currentState.handleOnShootChanged(true)

	state_changed.emit(lastState, currentState)

func getCurrentBloomValue() -> float:
	if currentState:
		return currentState.getCurrentBloomValue()

	return 0.0
