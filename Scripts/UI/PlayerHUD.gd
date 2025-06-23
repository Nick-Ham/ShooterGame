extends MenuBase
class_name PlayerHUD

@export_category("RefInternal")
@export var healthLabel : Label
@export var armorLabel : Label
@export var ammoLabel : Label
@export var armorHBox : HBoxContainer

# ===== Prototype stuff
@export_category("PrototypeRef")
@export var pistolDisplayLabel : Label
@export var junkBarrelDisplayLabel : Label
@export var hammerGunDisplayLabel : Label
@export_category("PrototypeWeaponData")
@export var pistolName : String = "Pistol"
@export var junkBarrelName : String = "JunkBarrel"
@export var hammerGunName : String = "Hammer"
# =====

var player : Character = null
var currentWeapon : Weapon = null

@onready var armoredHealth : ArmoredHealth = Util.getChildOfType(player, ArmoredHealth)
@onready var weaponManager : WeaponManager = Util.getChildOfType(player, WeaponManager)
@onready var ammoManager : AmmoManager = Util.getChildOfType(player, AmmoManager)

func _ready() -> void:
	assert(armoredHealth)
	assert(weaponManager)

	Util.safeConnect(armoredHealth.armor_changed, on_armor_changed)
	Util.safeConnect(armoredHealth.health_changed, on_health_changed)

	Util.safeConnect(weaponManager.weapon_equipped, on_weapon_equipped)
	Util.safeConnect(ammoManager.ammo_updated, on_ammo_updated)

	refresh()

func on_armor_changed(_inPreviousArmor : float, _inNewArmor : float) -> void:
	refresh()

func on_health_changed(_inPreviousHealth : float, _inNewHealth : float) -> void:
	refresh()

func refresh() -> void:
	refreshHealthLabel()
	refreshArmorLabel()
	refreshAmmoLabel()

	refreshPrototypeLabels()

func _physics_process(_delta: float) -> void:
	refreshPrototypeLabels()

func refreshPrototypeLabels() -> void:
	if !Util.isValid(weaponManager):
		return

	pistolDisplayLabel.visible = weaponManager.hasWeaponByName(pistolName)
	junkBarrelDisplayLabel.visible = weaponManager.hasWeaponByName(junkBarrelName)
	hammerGunDisplayLabel.visible = weaponManager.hasWeaponByName(hammerGunName)

	pistolDisplayLabel.modulate.a = 0.4
	junkBarrelDisplayLabel.modulate.a = 0.4
	hammerGunDisplayLabel.modulate.a = 0.4

	if !weaponManager.isWeaponEquipped():
		return

	if weaponManager.equippedWeaponData.weaponName == pistolName:
		pistolDisplayLabel.modulate.a = 1.0
	elif weaponManager.equippedWeaponData.weaponName == junkBarrelName:
		junkBarrelDisplayLabel.modulate.a = 1.0
	elif weaponManager.equippedWeaponData.weaponName == hammerGunName:
		hammerGunDisplayLabel.modulate.a = 1.0


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
	var maxAmmo : int = ammoManager.getAmmoSupply(currentWeapon.getWeaponData())

	var ammoText : String = str(currentAmmo) + " / " + str(maxAmmo)
	ammoLabel.text = ammoText

func on_ammo_updated(_inWeaponData : WeaponData, _inAmmo : int) -> void:
	refreshAmmoLabel()

func injectPlayer(inPlayer : Character) -> void:
	player = inPlayer

func on_weapon_equipped(_inWeaponData : WeaponData) -> void:
	fetchWeapon()
	refreshAmmoLabel()

func fetchWeapon() -> void:
	currentWeapon = weaponManager.getEquippedWeapon()

	if !currentWeapon:
		return

	Util.safeConnect(currentWeapon.ammo_updated, on_weapon_ammo_updated)

func on_weapon_ammo_updated(_inAmount : int) -> void:
	refreshAmmoLabel()
