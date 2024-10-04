extends Node
class_name Health

@export_category("Config")
@export var maxHealth : float = 1.0
@export var healthEnabled : bool = false

@onready var currentHealth : float = maxHealth

signal health_depleted(health : Health)
signal health_damaged(damage : float, newHealth : float)

func getEnabled() -> bool:
	return healthEnabled

func takeDamage(inDamage : float) -> void:
	currentHealth -= inDamage

	health_damaged.emit(inDamage, currentHealth)

	if currentHealth < 0.0:
		health_depleted.emit(self)
