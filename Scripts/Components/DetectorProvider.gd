extends Node
class_name DetectorProvider

@export_category("Ref")
@export var leftFloorDetector : RayCast3D
@export var rightFloorDetector : RayCast3D
@export var leftWallDetector : RayCast3D
@export var rightWallDetector : RayCast3D

func _ready() -> void:
	assert(leftFloorDetector)
	assert(rightFloorDetector)
	assert(leftWallDetector)
	assert(rightWallDetector)

func getFloorDetector(inIsLeft : bool) -> RayCast3D:
	return leftFloorDetector if inIsLeft else rightFloorDetector

func getWallDetector(inIsLeft : bool) -> RayCast3D:
	return leftWallDetector if inIsLeft else rightWallDetector
