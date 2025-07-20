@tool
extends Node3D
class_name MapPieceMarker

const directionKey : String = "direction"
const badKeyDefault : int = -1

@export var func_godot_properties : Dictionary = {}
@export var direction : int = -1

func _ready() -> void:
	if not Engine.is_editor_hint():
		var level : Level = Game.getGame(get_tree()).getLevel()
		var levelBuilder : LevelBuilder = level.getLevelBuilder()

		levelBuilder.registerDoorPieceMarker(self)

func _func_godot_build_complete() -> void:
	direction = func_godot_properties.get(directionKey, badKeyDefault)
	if direction == badKeyDefault:
		push_warning("Unable to read key: ", directionKey)

	print_debug(func_godot_properties)

	return

func getDirection() -> LevelUtil.Direction:
	return LevelUtil.intToDirection(direction)
