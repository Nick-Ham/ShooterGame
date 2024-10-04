extends CenterContainer
class_name Reticle

@export_category("Config")
@export var centerDotSize : float = 1.0
@export var reticleWidth : float = 0.5
@export var reticleColor : Color = Color.GRAY
@export var bloomReticleColor : Color = Color.SLATE_GRAY

@export var weaponStateManager : WeaponStateManager
@export var weaponManager : WeaponManager

const bloomToReticleConst : float = 5500.0

var currentWeaponData : WeaponData = null

func _enter_tree() -> void:
	Util.safeConnect(weaponManager.weapon_equipped, on_weapon_equipped)

func _ready() -> void:
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

	if currentWeaponData:
		var bloomAtCurve : float = currentWeaponData.bloomCurve.sample(weaponStateManager.getCurrentBloomValue())
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
