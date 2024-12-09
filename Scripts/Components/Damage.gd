extends Node
class_name Damage

@export_category("Config")
@export var damage : float = 1.0

func dealDamage(inTarget : Node3D, inSource : Node3D, inModifier : float = 1.0) -> bool:
	var overshieldHealth : OvershieldHealth = Util.getChildOfType(inTarget, OvershieldHealth)
	if overshieldHealth and !overshieldHealth.isHealthDepleted:
		overshieldHealth.takeDamage(damage * inModifier)
		EnvironmentEventBus.addDamageEvent(inSource, inTarget)
		return true

	var health : Health = Util.getChildOfType(inTarget, Health)
	if health and !health.isHealthDepleted:
		health.takeDamage(damage * inModifier)
		EnvironmentEventBus.addDamageEvent(inSource, inTarget)
		return true

	return false
