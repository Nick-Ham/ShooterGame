extends Node
class_name EnvironmentEffectManager

@onready var defaultBulletImpactScene : PackedScene = preload("res://Scenes/Effects/BulletImpactDecal.tscn")

func addBulletImpact(inPosition : Vector3, inImpactNormal : Vector3) -> void:
	var impactInstance : Impact = defaultBulletImpactScene.instantiate() as Impact
	get_parent().add_child(impactInstance)

	impactInstance.global_position = inPosition

	var normalRotated : Vector3 = inImpactNormal.rotated(Vector3.FORWARD, PI/2)

	if inImpactNormal.is_equal_approx(normalRotated):
		return

	impactInstance.look_at(impactInstance.global_transform.origin + inImpactNormal, normalRotated)
