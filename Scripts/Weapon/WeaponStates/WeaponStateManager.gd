extends Node
class_name WeaponStateManager

@export_category("Config")
@export var loggingEnabled : bool = false
@export var loggerCategory : String = "Weapon:StateManager:State"
@export var stateOnOutOfAmmo : String = "outOfAmmo"

@export_category("States")
@export var stateDefault : WeaponState
@export var stateOutOfAmmo : WeaponState

@onready var states : Array[WeaponState] = [
	stateDefault,
	stateOutOfAmmo
]

var currentState : WeaponState = null
var lastState : WeaponState = null
var controller : Controller = null

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var weaponManager : WeaponManager  = Util.getChildOfType(owningCharacter, WeaponManager)

signal state_changed(lastState : WeaponState, newState : WeaponState)
signal weapon_fired
signal ammo_updated(newAmmo : int)

var currentAmmo : int = 0

func _ready() -> void:
	assert(stateDefault)
	assert(stateOutOfAmmo)

	controller = Controller.getController(owningCharacter)
	if controller:
		bindToController(controller)

	if loggingEnabled:
		DebugLogger.registerTrackedValue(loggerCategory)

	var ammoManager : AmmoManager = Util.getChildOfType(owningCharacter, AmmoManager)
	if is_instance_valid(ammoManager):
		currentAmmo = ammoManager.getMagazineAmmo(getWeaponData())
	else:
		currentAmmo = getWeaponData().magazineSize

	bindToStates()
	Util.safeConnect(getWeapon().weapon_unequipped, on_weapon_unequipped)

func on_weapon_unequipped() -> void:
	var ammoManager : AmmoManager = Util.getChildOfType(owningCharacter, AmmoManager)
	if !is_instance_valid(ammoManager):
		return

	if currentAmmo != 0:
		ammoManager.setMagazineAmmo(getWeaponData(), currentAmmo)

func on_request_change_state(inStateKey : String) -> void:
	for state : WeaponState in states:
		if state.getStateKey() == inStateKey:
			changeState(state)
			return

	push_error("Attempted to enter non-existent state.")

func bindToStates() -> void:
	for state : WeaponState in states:
		state.request_change_state.connect(on_request_change_state)

func readyWeapon() -> void:
	changeState(stateDefault)

func getIsShooting() -> bool:
	if !controller:
		return false

	return controller.getIsShooting()

func getWeapon() -> Weapon:
	return get_parent() as Weapon

func getWeaponData() -> WeaponData:
	var weapon : Weapon = get_parent() as Weapon
	return weapon.getWeaponData()

func addController(inController : Controller) -> void:
	controller = inController
	bindToController(controller)

func bindToController(inController : Controller) -> void:
	Util.safeConnect(inController.shoot_changed, on_shoot_changed)
	Util.safeConnect(inController.reload_changed, on_reload_changed)

func on_shoot_changed(inIsShooting : bool) -> void:
	if currentState:
		currentState.handleOnShootChanged(inIsShooting)

func on_reload_changed(inIsReloading : bool) -> void:
	if currentState:
		currentState.handleOnReloadChanged(inIsReloading)

func changeState(inNewState : WeaponState) -> void:
	if currentState:
		currentState.stateExiting()

	lastState = currentState
	currentState = inNewState

	currentState.stateEntering()

	if loggingEnabled:
		DebugLogger.updateTrackedValue(loggerCategory, currentState.getStateKey())

	if is_instance_valid(controller) and controller.getIsShooting():
		currentState.handleOnShootChanged(true)

	state_changed.emit(lastState, currentState)

func getCurrentBloomValue() -> float:
	if currentState:
		return currentState.getCurrentBloomValue()

	return 0.0

func getCurrentAmmo() -> int:
	return currentAmmo

func consumeAmmo(inAmount : int) -> void:
	if weaponManager.getInfiniteAmmo():
		return

	var weaponData : WeaponData = getWeaponData()

	var lastAmmo : int = currentAmmo
	currentAmmo = clampi(currentAmmo - inAmount, 0, weaponData.magazineSize)

	ammo_updated.emit(currentAmmo)

func setCurrentAmmo(inAmmo : int) -> void:
	currentAmmo = inAmmo
	ammo_updated.emit(currentAmmo)

func isCurrentState(inWeaponState : WeaponState) -> bool:
	if !currentState:
		return false

	if inWeaponState != currentState:
		return false

	return true
