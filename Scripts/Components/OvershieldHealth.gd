extends Health
class_name OvershieldHealth

@export_category("Config")
@export var rechargeDelay : float = 3.0
@export var rechargeTime : float = 2.0
@export var destroyedRechargeDelay : float = 6.0

var isRecharging : bool = false
var isRecharged : bool = true
var timeSinceLastDamage : float = 0.0

@onready var rechargeDelayTimer : Timer = Timer.new()

signal shield_recharging
signal shield_resetting
signal shield_recharged

func _ready() -> void:
	rechargeDelayTimer.wait_time = rechargeDelay
	add_child(rechargeDelayTimer)

	Util.safeConnect(rechargeDelayTimer.timeout, on_rechargeDelayTimer_timeout)

func _process(delta: float) -> void:
	if isRecharging and !isRecharged:
		rechargeUpdate(delta)

func healthDepleted() -> void:
	rechargeDelayTimer.start(destroyedRechargeDelay)

	super.healthDepleted()

func takeDamage(inDamage : float) -> void:
	if isHealthDepleted:
		return

	super.takeDamage(inDamage)

	rechargeDelayTimer.start()
	isRecharged = false
	isRecharging = false

func rechargeUpdate(inDelta : float) -> void:
	var amountToRecharge : float = maxHealth / rechargeTime * inDelta
	restoreHealth(amountToRecharge)

	if isFullHealth():
		isRecharged = true
		shield_recharged.emit()

func on_rechargeDelayTimer_timeout() -> void:
	isRecharging = true

	if isHealthDepleted:
		shield_resetting.emit()
	else:
		shield_recharging.emit()
