extends Node
class_name Health

@export_category("Config")
@export var maxHealth : float = 1.0

var currentHealth : float = maxHealth

signal health_depleted(health : Health)
signal health_damaged(damage : float, newHealth : float)
signal health_restored(amount : float, newHealth : float)

var isHealthDepleted : bool = false

func _enter_tree() -> void:
	currentHealth = maxHealth

func isFullHealth() -> bool:
	return is_equal_approx(currentHealth, maxHealth)

func getMaxHealth() -> float:
	return maxHealth

func getCurrentHealth() -> float:
	return currentHealth

func takeDamage(inDamage : float) -> void:
	if isHealthDepleted:
		return

	currentHealth -= inDamage

	health_damaged.emit(inDamage, currentHealth)

	if currentHealth < 0.0:
		healthDepleted()

func healthDepleted() -> void:
	isHealthDepleted = true
	health_depleted.emit(self)

func restoreHealth(inAmount : float) -> void:
	currentHealth += inAmount
	currentHealth = clampf(currentHealth, 0.0, maxHealth)

	if isHealthDepleted:
		isHealthDepleted = false

	health_restored.emit(inAmount, currentHealth)
