extends MenuBase
class_name PlayerHUD

@export_category("RefInternal")
@export var shieldBar : ProgressBar
@export var ammoLabel : Label

var player : Character = null
var currentWeapon : Weapon = null

@onready var overshieldHealth : OvershieldHealth = Util.getChildOfType(player, OvershieldHealth)
@onready var weaponManager : WeaponManager = Util.getChildOfType(player, WeaponManager)

func _ready() -> void:
	assert(overshieldHealth)
	assert(shieldBar)

	Util.safeConnect(overshieldHealth.health_damaged, on_health_damaged)
	Util.safeConnect(overshieldHealth.health_restored, on_health_restored)

	Util.safeConnect(weaponManager.weapon_equipped, on_weapon_equipped)

	refreshShieldBar()

func injectPlayer(inPlayer : Character) -> void:
	player = inPlayer

func on_health_damaged(_inDamage : float, _inNewHealth : float) -> void:
	refreshShieldBar()

func on_health_restored(_inAmount : float, _inNewHealth : float) -> void:
	refreshShieldBar()

func refreshShieldBar() -> void:
	shieldBar.min_value = 0.0

	if !overshieldHealth:
		shieldBar.max_value = 0
		shieldBar.value = 0
		return

	shieldBar.max_value = overshieldHealth.getMaxHealth()
	shieldBar.value = overshieldHealth.getCurrentHealth()

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

func refreshAmmoLabel() -> void:
	if !currentWeapon:
		ammoLabel.text = "0 / 0"
		return

	var currentAmmo : int = currentWeapon.getCurrentAmmo()
	var maxAmmo : int = currentWeapon.getWeaponData().magazineSize

	var ammoText : String = str(currentAmmo) + " / " + str(maxAmmo)
	ammoLabel.text = ammoText
