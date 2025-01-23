extends Node
class_name PlayerWeaponEquipController

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var playerController : PlayerController = Util.getChildOfType(owningCharacter, PlayerController)
@onready var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)

var weapon1 : WeaponData = WeaponLibrary.pistolWeaponData
var weapon2 : WeaponData = WeaponLibrary.junkBarrelWeaponData
var weapon3 : WeaponData = WeaponLibrary.hammerGunWeaponData
var weapon4 : WeaponData = null
var weapon5 : WeaponData = null


func _ready() -> void:
	Util.safeConnect(playerController.weapon1_triggered, on_weapon1_triggered)
	Util.safeConnect(playerController.weapon2_triggered, on_weapon2_triggered)
	Util.safeConnect(playerController.weapon3_triggered, on_weapon3_triggered)
	Util.safeConnect(playerController.weapon4_triggered, on_weapon4_triggered)
	Util.safeConnect(playerController.weapon5_triggered, on_weapon5_triggered)

func on_weapon1_triggered() -> void:
	weaponManager.tryEquip(weapon1)

func on_weapon2_triggered() -> void:
	weaponManager.tryEquip(weapon2)

func on_weapon3_triggered() -> void:
	weaponManager.tryEquip(weapon3)

func on_weapon4_triggered() -> void:
	weaponManager.tryEquip(weapon4)

func on_weapon5_triggered() -> void:
	weaponManager.tryEquip(weapon5)
