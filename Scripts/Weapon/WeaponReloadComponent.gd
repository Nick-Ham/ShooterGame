extends Node
class_name WeaponReloadComponent

@onready var weaponStateManager : WeaponStateManager = Util.getChildOfType(get_parent(), WeaponStateManager)
@onready var weaponAnimationController : WeaponAnimationController = Util.getChildOfType(get_parent(), WeaponAnimationController)

var ammoManager : AmmoManager

signal reload_complete

func _ready() -> void:
	var owningCharacter : Character = Character.getOwningCharacter(self)
	if owningCharacter:
		ammoManager = Util.getChildOfType(owningCharacter, AmmoManager)

	Util.safeConnect(weaponAnimationController.reload_ended, on_reload_ended)

func reload() -> void:
	var currentWeaponData : WeaponData = weaponStateManager.getWeaponData()

	if weaponStateManager.getCurrentAmmo() == currentWeaponData.magazineSize:
		return

	if ammoManager.getAmmoSupply(currentWeaponData) <= 0:
		return

	ammoManager.setMagazineAmmo(currentWeaponData, weaponStateManager.getCurrentAmmo())
	weaponStateManager.setCurrentAmmo(0)

	weaponAnimationController.playReload()

func on_reload_ended() -> void:
	var currentWeaponData : WeaponData = weaponStateManager.getWeaponData()
	var magazineSize : int = currentWeaponData.magazineSize

	if !is_instance_valid(ammoManager):
		weaponStateManager.setCurrentAmmo(magazineSize)
		reload_complete.emit()
		return

	var remainingAmmo : int = ammoManager.getMagazineAmmo(currentWeaponData)
	var ammoRequired : int = magazineSize - remainingAmmo
	var ammoFetched : int = mini(ammoRequired, clampi(ammoManager.getAmmoSupply(currentWeaponData), 0, magazineSize))

	ammoManager.consumeAmmoSupply(currentWeaponData, ammoFetched)
	weaponStateManager.setCurrentAmmo(remainingAmmo + ammoFetched)

	remainingAmmo = 0

	reload_complete.emit()
