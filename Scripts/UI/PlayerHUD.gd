extends MenuBase
class_name PlayerHUD

@export_category("RefInternal")
@export var shieldBar : ProgressBar

var player : Character = null
@onready var overshieldHealth : OvershieldHealth = Util.getChildOfType(player, OvershieldHealth)

func _ready() -> void:
	assert(overshieldHealth)
	assert(shieldBar)

	Util.safeConnect(overshieldHealth.health_damaged, on_health_damaged)
	Util.safeConnect(overshieldHealth.health_restored, on_health_restored)

	refreshShieldBar()

func injectPlayer(inPlayer : Character) -> void:
	player = inPlayer

func on_health_damaged(_inDamage : float, _inNewHealth : float) -> void:
	refreshShieldBar()

func on_health_restored(_inAmount : float, _inNewHealth : float) -> void:
	refreshShieldBar()

func refreshShieldBar() -> void:
	shieldBar.min_value = 0.0
	shieldBar.max_value = overshieldHealth.getMaxHealth()
	shieldBar.value = overshieldHealth.getCurrentHealth()
