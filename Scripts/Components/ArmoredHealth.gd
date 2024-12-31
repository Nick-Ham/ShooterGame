extends Health
class_name ArmoredHealth

@export_category("Config")
@export var maxArmor : float = 100.0

var currentArmor : float = 100.0

signal armor_depleted
signal armor_changed(inPreviousArmor : float, inNewArmor : float)

func getMaxArmor() -> float:
	return maxArmor

func getCurrentArmor() -> float:
	return currentArmor

func getArmorDepleted() -> bool:
	return is_zero_approx(currentArmor)

func takeDamage(inDamage : float) -> void:
	if getArmorDepleted():
		super.takeDamage(inDamage)

	var startingArmor : float = currentArmor
	var startingHealth : float = currentHealth

	if inDamage < currentArmor:
		currentArmor -= inDamage / 2.0
		currentHealth -= inDamage / 2.0
	else:
		var armorDamage : float = currentArmor
		var remainingDamage : float = inDamage - armorDamage
		currentArmor = 0
		currentHealth -= armorDamage + remainingDamage

	armor_changed.emit(startingArmor, currentArmor)
	health_changed.emit(startingHealth, currentHealth)

	if !startingArmor <= 0 and currentArmor <= 0:
		armor_depleted.emit()

	if !startingHealth <= 0 and currentHealth <= 0:
		health_depleted.emit(self)
