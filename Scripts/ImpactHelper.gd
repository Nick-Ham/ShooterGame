extends Node
class_name ImpactHelper

static var defaultImpactScene : PackedScene = preload("res://Scenes/Effects/BulletImpactDecal.tscn")

static var shieldImpactScene : PackedScene = preload("res://Scenes/Effects/ShieldBulletImpact.tscn")
static var metalImpactScene : PackedScene = preload("res://Scenes/Effects/BulletImpactDecal.tscn")

static func createMetalImpact(inParent : Node3D, inHitPosition : Vector3, inHitNormal : Vector3) -> Impact:
	var metalImpact : Impact = createImpact(inParent, inHitPosition, inHitNormal, metalImpactScene)
	return metalImpact

static func createShieldImpact(inParent : Node3D, inHitPosition : Vector3, inHitNormal : Vector3) -> Impact:
	var shieldImpact : Impact = createImpact(inParent, inHitPosition, inHitNormal, shieldImpactScene)
	return shieldImpact

static func createImpact(inParent : Node3D, inHitPosition : Vector3, inHitNormal : Vector3, impactScene : PackedScene = defaultImpactScene) -> Impact:
	var impactInstance : Impact = impactScene.instantiate() as Impact
	inParent.add_child(impactInstance)

	impactInstance.global_position = inHitPosition

	var normalRotated : Vector3 = inHitNormal.rotated(Vector3.FORWARD, PI/2)

	if inHitNormal.is_equal_approx(normalRotated):
		return

	impactInstance.look_at(impactInstance.global_transform.origin + inHitNormal, normalRotated)

	return impactInstance
