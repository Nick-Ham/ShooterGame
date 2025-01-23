extends Node
class_name AmmoManager

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var itemManager : ItemManager = Util.getChildOfType(owningCharacter, ItemManager)
@onready var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)

# Needs to be typed in gd 4.4 to maintain type safety
var weaponAmmoSupply : Dictionary = {}
var weaponAmmo : Dictionary = {}

var weapons : Array[WeaponData] = WeaponLibrary.getWeapons()

signal ammo_updated(inWeaponData : WeaponData, inAmmo : int)

func _ready() -> void:
	assert(owningCharacter)
	assert(itemManager)

	for weaponData : WeaponData in weapons:
		weaponAmmoSupply[weaponData] = int(0)

	Util.safeConnect(itemManager.item_added, on_item_added)

func setMagazineAmmo(inWeaponData : WeaponData, inAmmo : int) -> void:
	weaponAmmo[inWeaponData] = inAmmo

func getMagazineAmmo(inWeaponData : WeaponData) -> int:
	if !weaponAmmo.has(inWeaponData):
		return 0

	return weaponAmmo[inWeaponData]

func getAmmoSupply(inWeaponData : WeaponData) -> int:
	if !weaponAmmoSupply.has(inWeaponData):
		return 0

	return weaponAmmoSupply[inWeaponData] as int

func consumeAmmoSupply(inWeaponData : WeaponData, inAmount : int) -> void:
	if inAmount <= 0 || !weaponAmmoSupply.has(inWeaponData):
		return

	weaponAmmoSupply[inWeaponData] = clampi(weaponAmmoSupply[inWeaponData] - inAmount, 0, weaponAmmoSupply[inWeaponData])

	ammo_updated.emit(inWeaponData, weaponAmmoSupply[inWeaponData])

func on_item_added(inNewItem : Item) -> void:
	var itemAsWeapon : WeaponItem = inNewItem as WeaponItem

	if is_instance_valid(itemAsWeapon) and weaponAmmoSupply.has(itemAsWeapon.weaponData):

		weaponAmmoSupply[itemAsWeapon.weaponData] = clampi(
			weaponAmmoSupply[itemAsWeapon.weaponData] + itemAsWeapon.weaponData.magazineSize,
			0,
			itemAsWeapon.weaponData.maxAmmoStorage
		)

		ammo_updated.emit(itemAsWeapon.weaponData, weaponAmmoSupply[itemAsWeapon.weaponData])
		itemManager.consumeItem(inNewItem)

		return

	var itemAsQuantity : QuantityItem = inNewItem as QuantityItem

	if !is_instance_valid(itemAsQuantity):
		return

	var correspondingWeapon : WeaponData = null
	for weapon : WeaponData in weapons:
		if weapon.weaponAmmoItem == null:
			continue

		if weapon.weaponAmmoItem != itemAsQuantity:
			continue

		correspondingWeapon = weapon
		break

	if !is_instance_valid(correspondingWeapon) || !weaponAmmoSupply.has(correspondingWeapon):
		return

	weaponAmmoSupply[correspondingWeapon] = clampi(
		weaponAmmoSupply[correspondingWeapon] + itemAsQuantity.quantity,
		0,
		correspondingWeapon.maxAmmoStorage
	)

	ammo_updated.emit(correspondingWeapon, weaponAmmoSupply[correspondingWeapon])
	itemManager.consumeItem(inNewItem)
