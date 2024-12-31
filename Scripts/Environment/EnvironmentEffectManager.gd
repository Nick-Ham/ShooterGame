extends Node
class_name EnvironmentEffectManager

func addBulletImpact(inPosition : Vector3, inImpactNormal : Vector3) -> void:
	var level : Level = get_parent() as Level
	ImpactHelper.createImpact(level, inPosition, inImpactNormal)

func addExplosion(inPosition : Vector3) -> ExplosionEffect:
	var level : Level = get_parent() as Level
	return ImpactHelper.createExplosion(level, inPosition)
