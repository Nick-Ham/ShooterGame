extends Item
class_name WeaponItem

@export_category("Config")
@export var weaponData : WeaponData

func getItemCategory() -> ItemCategory:
	return ItemCategory.Weapon

func getModel() -> PackedScene:
	return weaponData.weaponModelScene
