extends Node
class_name WeaponManager

@export_category("Config")
@export var defaultWeapon : WeaponData

var equippedWeaponData : WeaponData = null

func _ready() -> void:
	if WeaponData.validateWeapon(defaultWeapon):
		equip(defaultWeapon)

func equip(inWeaponData : WeaponData) -> void:
	equippedWeaponData = inWeaponData

func getEquippedWeaponData() -> WeaponData:
	return equippedWeaponData
