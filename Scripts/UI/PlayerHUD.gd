extends MenuBase
class_name PlayerHUD

@export_category("RefInternal")
@export var healthLabel : Label
@export var armorLabel : Label
@export var ammoLabel : Label
@export var armorHBox : HBoxContainer

var player : Character = null
var currentWeapon : Weapon = null

@onready var armoredHealth : ArmoredHealth = Util.getChildOfType(player, ArmoredHealth)
@onready var weaponManager : WeaponManager = Util.getChildOfType(player, WeaponManager)

func _ready() -> void:
	assert(armoredHealth)
	assert(weaponManager)

	Util.safeConnect(armoredHealth.armor_changed, on_armor_changed)
	Util.safeConnect(armoredHealth.health_changed, on_health_changed)

	Util.safeConnect(weaponManager.weapon_equipped, on_weapon_equipped)

	refresh()

func on_armor_changed(_inPreviousArmor : float, _inNewArmor : float) -> void:
	refresh()

func on_health_changed(_inPreviousHealth : float, _inNewHealth : float) -> void:
	refresh()

func refresh() -> void:
	refreshHealthLabel()
	refreshArmorLabel()
	refreshAmmoLabel()

func refreshHealthLabel() -> void:
	healthLabel.text = str(int(armoredHealth.getCurrentHealth()))

func refreshArmorLabel() -> void:
	armorLabel.text = str(int(armoredHealth.getCurrentArmor()))
	armorHBox.visible = !armoredHealth.getArmorDepleted()

func refreshAmmoLabel() -> void:
	if !currentWeapon:
		ammoLabel.text = "0 / 0"
		return

	var currentAmmo : int = currentWeapon.getCurrentAmmo()
	var maxAmmo : int = currentWeapon.getWeaponData().magazineSize

	var ammoText : String = str(currentAmmo) + " / " + str(maxAmmo)
	ammoLabel.text = ammoText


func injectPlayer(inPlayer : Character) -> void:
	player = inPlayer

func on_weapon_equipped(_inWeaponData : WeaponData) -> void:
	fetchWeapon()
	refreshAmmoLabel()

func fetchWeapon() -> void:
	currentWeapon = weaponManager.getEquippedWeapon()

	if !currentWeapon:
		return

	Util.safeConnect(currentWeapon.ammo_updated, on_ammo_updated)

func on_ammo_updated(_inAmount : int) -> void:
	refreshAmmoLabel()
