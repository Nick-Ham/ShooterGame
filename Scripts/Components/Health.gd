extends Node
class_name Health

@export_category("Config")
@export var maxHealth : float = 100.0

var currentHealth : float = maxHealth

signal health_depleted(health : Health)
signal health_changed(inPreviousHealth : float, inNewHealth : float)

var isHealthDepleted : bool = false

func _enter_tree() -> void:
	currentHealth = maxHealth

func isFullHealth() -> bool:
	return is_equal_approx(currentHealth, maxHealth)

func getMaxHealth() -> float:
	return maxHealth

func getCurrentHealth() -> float:
	return currentHealth

func getHealthDepleted() -> bool:
	return isHealthDepleted

func takeDamage(inDamage : float) -> void:
	if isHealthDepleted:
		return

	var startingHealth : float = currentHealth
	currentHealth -= inDamage

	health_changed.emit(startingHealth, currentHealth)

	if currentHealth <= 0.0:
		healthDepleted()

func healthDepleted() -> void:
	isHealthDepleted = true
	health_depleted.emit(self)

func restoreHealth(inAmount : float) -> void:
	var startingHealth : float = currentHealth

	currentHealth += inAmount
	currentHealth = clampf(currentHealth, 0.0, maxHealth)

	if isHealthDepleted:
		isHealthDepleted = false

	health_changed.emit(startingHealth, currentHealth)

func resetHealth() -> void:
	currentHealth = maxHealth
