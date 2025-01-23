extends WeaponState
class_name WeaponStateOutOfAmmo

@export_category("Ref")
@export var emptyFirePlayer : AudioStreamPlayer3D

@export_category("Config")
@export var stateOnReload : String = "default"

@onready var weaponStateManager : WeaponStateManager = get_parent() as WeaponStateManager
@onready var weaponReloadComponent : WeaponReloadComponent = Util.getChildOfType(weaponStateManager.get_parent(), WeaponReloadComponent)

func _ready() -> void:
	assert(weaponReloadComponent)

	Util.safeConnect(weaponReloadComponent.reload_complete, on_reload_complete)

func stateEntering() -> void:
	return

func handleOnShootChanged(inIsShooting : bool) -> void:
	if !inIsShooting:
		return

	emptyFirePlayer.play()

func handleOnReloadChanged(inIsReloading : bool) -> void:
	if !inIsReloading:
		return

	weaponReloadComponent.reload()

func on_reload_complete() -> void:
	if !weaponStateManager.isCurrentState(self):
		return

	request_change_state.emit(stateOnReload)

func getStateKey() -> String:
	return "outOfAmmo"
