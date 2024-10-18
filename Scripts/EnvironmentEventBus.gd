extends Node
class_name EnvironmentEventBus

signal sound_triggered(inSource : Node3D)

static func addEnvironmentSound(inSource : Node3D) -> void:
	var level : Level = Game.getGame(inSource.get_tree()).getLevel()
	level.getEnvironmentEventBus().sound_triggered.emit(inSource)
