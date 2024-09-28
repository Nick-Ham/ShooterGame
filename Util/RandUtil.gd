extends Node
class_name RandUtil

static func rollDice(chance : float) -> float:
	var randRoll : float = randf()
	return chance > randRoll

static func getRandomOffset(inMaxRadius : float) -> Vector2:
	return Vector2(randf_range(-inMaxRadius, inMaxRadius), randf_range(-inMaxRadius, inMaxRadius))

static func randf_range_vector2(inVector2 : Vector2) -> float:
	return randf_range(inVector2.x, inVector2.y)
