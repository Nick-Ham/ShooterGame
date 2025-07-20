extends Node3D
class_name MapPiece

var direction : LevelUtil.Direction = LevelUtil.Direction.NORTH

func setDirection(inDirection : LevelUtil.Direction) -> void:
	rotation.y = -PI / 2.0 * inDirection
