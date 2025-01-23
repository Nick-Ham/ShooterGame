extends Node
class_name WeaponManager

@export_category("Ref")
@export var weaponModelPivot : Node3D
@export var handsAnimationPlayer : AnimationPlayer

@export_category("Config")
@export var defaultWeapon : WeaponData
@export var useFirstPersonMode : bool

var equippedWeaponData : WeaponData = null
var equippedWeapon : Weapon = null

const readyWeaponAnimationKey : String = "ReadyWeapon"

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

signal weapon_equipped(inWeaponData : WeaponData)
signal weapon_unequipped
signal weapon_shot

const handsVisualLayer : int = 2

var addedWeapons : Array[WeaponData] = []

func _ready() -> void:
	assert(weaponModelPivot)

	if WeaponData.validateWeapon(defaultWeapon):
		equip(defaultWeapon, useFirstPersonMode)

	var itemManager : ItemManager = Util.getChildOfType(owningCharacter, ItemManager)
	if itemManager:
		Util.safeConnect(itemManager.item_added, on_item_added)

func on_item_added(inItem : Item) -> void:
	var itemAsWeaponItem : WeaponItem = inItem as WeaponItem
	if !itemAsWeaponItem:
		return

	if addedWeapons.has(itemAsWeaponItem.weaponData):
		return

	# First Find
	var ammoManager : AmmoManager = Util.getChildOfType(owningCharacter, AmmoManager)
	if is_instance_valid(ammoManager):
		ammoManager.setMagazineAmmo(itemAsWeaponItem.weaponData, itemAsWeaponItem.weaponData.magazineSize)

	addedWeapons.append(itemAsWeaponItem.weaponData)
	equip(itemAsWeaponItem.weaponData, useFirstPersonMode)

func tryEquip(inWeaponData : WeaponData) -> void:
	if !addedWeapons.has(inWeaponData):
		return

	equip(inWeaponData, true)

func equip(inWeaponData : WeaponData, firstPersonMode : bool = true) -> void:
	if !WeaponData.validateWeapon(inWeaponData):
		return

	if is_instance_valid(equippedWeapon):
		if equippedWeapon.getWeaponData() == inWeaponData:
			return
		else:
			unequip()

	equippedWeaponData = inWeaponData

	equippedWeapon = equippedWeaponData.weaponScene.instantiate() as Weapon
	equippedWeapon.injectWeaponData(equippedWeaponData)

	weaponModelPivot.add_child(equippedWeapon)

	if firstPersonMode:
		setModelVisibilityToHands(equippedWeapon)

	if handsAnimationPlayer:
		handsAnimationPlayer.stop()
		handsAnimationPlayer.play(readyWeaponAnimationKey)
	else:
		readyWeapon.call_deferred()

	weapon_equipped.emit(equippedWeaponData)

func unequip() -> void:
	equippedWeaponData = null
	equippedWeapon.unequip()
	equippedWeapon.queue_free()

	weapon_unequipped.emit()

func readyWeapon() -> void:
	if equippedWeapon:
		equippedWeapon.readyWeapon()

func getEquippedWeapon() -> Weapon:
	return equippedWeapon

func getEquippedWeaponData() -> WeaponData:
	return equippedWeaponData

func setModelVisibilityToHands(inRoot : Node3D) -> void:
	var childrenToProcess : Array[Node] = inRoot.get_children()

	while !childrenToProcess.is_empty():
		var child : Node = childrenToProcess.pop_back()
		childrenToProcess.append_array(child.get_children())

		var childAsMesh : MeshInstance3D = child as MeshInstance3D
		if !childAsMesh:
			continue

		childAsMesh.layers = handsVisualLayer
