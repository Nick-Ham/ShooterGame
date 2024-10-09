extends Node
class_name EnvironmentEffectManager

func addBulletImpact(inPosition : Vector3, inImpactNormal : Vector3) -> void:
	var level : Level = get_parent() as Level
	ImpactHelper.createImpact(level, inPosition, inImpactNormal)
