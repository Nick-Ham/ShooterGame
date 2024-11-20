extends CenterContainer
class_name Reticle

@export_category("Config")
@export var centerDotSize : float = 1.0
@export var reticleWidth : float = 0.5
@export var reticleColor : Color = Color.GRAY
@export var bloomReticleColor : Color = Color.SLATE_GRAY

const bloomToReticleConst : float = 5500.0

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

var currentWeaponData : WeaponData = null

func _enter_tree() -> void:
	return

func _ready() -> void:
	var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)
	assert(weaponManager)

	Util.safeConnect(weaponManager.weapon_equipped, on_weapon_equipped)

	queue_redraw()

func on_weapon_equipped(inWeaponData : WeaponData) -> void:
	loadWeaponData(inWeaponData)

func loadWeaponData(inWeaponData : WeaponData) -> void:
	currentWeaponData = inWeaponData

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var screenCenter : Vector2 = get_viewport().size / 2.0
	draw_circle(screenCenter, centerDotSize, reticleColor)

	var weaponManager : WeaponManager = Util.getChildOfType(owningCharacter, WeaponManager)
	var currentWeapon : Weapon = weaponManager.getEquippedWeapon()

	if currentWeaponData and currentWeapon:
		var bloomAtCurve : float = currentWeaponData.bloomCurve.sample(currentWeapon.getCurrentBloomValue())
		var bloomMapped : float = remap(
				bloomAtCurve,
				0.0,
				1.0,
				currentWeaponData.baseBloomRadius,
				currentWeaponData.maxBloomRadius
			) * getBloomToReticleScalar()

		draw_circle(screenCenter, currentWeaponData.maxBloomRadius * getBloomToReticleScalar() * 1.2, reticleColor, false, reticleWidth, true)
		draw_circle(screenCenter, bloomMapped, bloomReticleColor, false, reticleWidth, true)

func getBloomToReticleScalar() -> float:
	return bloomToReticleConst
