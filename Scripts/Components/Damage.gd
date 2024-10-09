extends Node
class_name Damage

@export_category("Config")
@export var damage : float = 1.0

func dealDamage(inTarget : Node, inModifier : float = 1.0) -> bool:
	var overshieldHealth : OvershieldHealth = Util.getChildOfType(inTarget, OvershieldHealth)
	if overshieldHealth:
		overshieldHealth.takeDamage(damage * inModifier)
		return true

	var health : Health = Util.getChildOfType(inTarget, Health)
	if health:
		health.takeDamage(damage * inModifier)
		return true

	return false
