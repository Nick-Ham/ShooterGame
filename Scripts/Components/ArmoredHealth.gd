extends Health
class_name ArmoredHealth

@export_category("Config")
@export var maxArmor : float = 100.0

var currentArmor : float = 100.0

signal armor_depleted
signal armor_changed(inPreviousArmor : float, inNewArmor : float)

const armorDamageAbsorption : float = .66 # 0 -> 1.0

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

	var damageToArmor : float = inDamage * armorDamageAbsorption
	var damageToHealth : float = inDamage * (1.0 - armorDamageAbsorption)

	currentArmor -= damageToArmor
	if currentArmor < 0.0:
		damageToHealth += abs(currentArmor)
		currentArmor = 0.0

	currentHealth -= damageToHealth

	if !is_equal_approx(startingArmor, currentArmor):
		armor_changed.emit(startingArmor, currentArmor)

	if !is_equal_approx(startingHealth, currentHealth):
		health_changed.emit(startingHealth, currentHealth)

	if !startingArmor <= 0 and currentArmor <= 0:
		armor_depleted.emit()

	if !startingHealth <= 0 and currentHealth <= 0:
		health_depleted.emit(self)
