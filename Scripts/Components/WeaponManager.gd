extends Node
class_name WeaponManager

@export_category("Ref")
@export var weaponModelPivot : Node3D
@export var handsAnimationPlayer : AnimationPlayer

@export_category("Config")
@export var defaultWeapon : WeaponData

var equippedWeaponData : WeaponData = null
var equippedWeapon : Weapon = null

const readyWeaponAnimationKey : String = "ReadyWeapon"

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

signal weapon_equipped(inWeaponData : WeaponData)

const handsVisualLayer : int = 2

func _ready() -> void:
	assert(weaponModelPivot)

	if WeaponData.validateWeapon(defaultWeapon):
		equip(defaultWeapon)

	var itemManager : ItemManager = Util.getChildOfType(owningCharacter, ItemManager)
	if itemManager:
		Util.safeConnect(itemManager.item_added, on_item_added)

func on_item_added(inItem : Item) -> void:
	var itemAsWeaponItem : WeaponItem = inItem as WeaponItem
	if !itemAsWeaponItem:
		return

	equip(itemAsWeaponItem.weaponData)

func equip(inWeaponData : WeaponData) -> void:
	if !WeaponData.validateWeapon(inWeaponData):
		return

	equippedWeaponData = inWeaponData

	equippedWeapon = equippedWeaponData.weaponScene.instantiate() as Weapon
	equippedWeapon.injectWeaponData(equippedWeaponData)

	weaponModelPivot.add_child(equippedWeapon)

	setModelVisibilityToHands(equippedWeapon)

	if handsAnimationPlayer:
		handsAnimationPlayer.play(readyWeaponAnimationKey)
	else:
		readyWeapon()

	weapon_equipped.emit(equippedWeaponData)

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
