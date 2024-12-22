extends Node
class_name WeaponReloadComponent

@onready var weaponStateManager : WeaponStateManager = Util.getChildOfType(get_parent(), WeaponStateManager)
@onready var weaponAnimationController : WeaponAnimationController = Util.getChildOfType(get_parent(), WeaponAnimationController)

signal reload_complete

func _ready() -> void:
	Util.safeConnect(weaponAnimationController.reload_ended, on_reload_ended)

func reload() -> void:
	if weaponStateManager.getCurrentAmmo() == weaponStateManager.getWeaponData().magazineSize:
		return

	weaponStateManager.setCurrentAmmo(0)

	weaponAnimationController.playReload()

func on_reload_ended() -> void:
	weaponStateManager.setCurrentAmmo(weaponStateManager.getWeaponData().magazineSize)
	reload_complete.emit()
