extends CharacterHealthManager
class_name PlayerHealthManager

@onready var overshieldHealth : OvershieldHealth = Util.getChildOfType(character, OvershieldHealth)

func _ready() -> void:
	super._ready()

	Util.safeConnect(overshieldHealth.shield_recharged, on_shield_recharged)

func on_shield_recharged() -> void:
	health.resetHealth()

func on_health_depleted(inHealth : Health) -> void:
	character.destroyCharacter()

	var playerController : PlayerController = Util.getChildOfType(character, PlayerController)
	playerController.detach()

	inHealth.queue_free()

	if overshieldHealth:
		overshieldHealth.queue_free()
