extends Object
class_name LevelUtil

enum Direction {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

static func intToDirection(inInt : int) -> Direction:
	var newDirection : Direction = clampi(inInt, 0, 3) as Direction
	return newDirection
