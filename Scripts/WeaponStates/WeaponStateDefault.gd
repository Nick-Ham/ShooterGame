extends WeaponState
class_name WeaponStateDefault

@export var shootSoundPlayer : AudioStreamPlayer3D
@export var shootRecoilPunch : Punch

var shootingLoggerCategory : String = "isTryShooting"

var magazineSize : int = 15
var delayBetweenShots : float = 0.20

var readyToFire : bool = true

@onready var shootDelayTimer : Timer = Timer.new()

func _ready() -> void:
	add_child(shootDelayTimer)
	shootDelayTimer.wait_time = delayBetweenShots
	Util.safeConnect(shootDelayTimer.timeout, on_shootDelayTimer_timeout)

func on_shootDelayTimer_timeout() -> void:
	readyToFire = true

	if !getStateManager().getIsShooting():
		return

	shoot()

func getStateKey() -> String:
	return "default"

func shoot() -> void:
	if !readyToFire:
		return
	readyToFire = false

	shootDelayTimer.start()
	shootSoundPlayer.play()

	var equippedWeaponData : WeaponData = getStateManager().getWeaponManager().getEquippedWeaponData()

	shootRecoilPunch.addRotationPunch(equippedWeaponData.getRandomRecoilRotation())
	shootRecoilPunch.addTranslationPunch(equippedWeaponData.getRandomRecoilTranslation())

func handleOnShootChanged(inIsShooting : bool) -> void:
	if !inIsShooting:
		return

	shoot()
