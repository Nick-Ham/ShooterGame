extends Node
class_name DebugUtil

static func spawnDebugSphere(inPosition : Vector3, inTree : SceneTree) -> void:
	var debugSphere : DebugSphere = DebugSphere.new()
	inTree.current_scene.add_child(debugSphere)
	debugSphere.global_position = inPosition

static func spawnDebugTrail(inPositions : Array[Vector3], inTree : SceneTree) -> void:
	var debugTrail : DebugTrail = DebugTrail.new()
	inTree.current_scene.add_child(debugTrail)
	debugTrail.addPoints(inPositions)
