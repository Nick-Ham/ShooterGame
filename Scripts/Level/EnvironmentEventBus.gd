extends Node
class_name EnvironmentEventBus

signal sound_triggered(inSource : Node3D)
signal item_picked_up(inSource : Node3D, item : Item)
signal damage_event(inSource : Node3D, inTarget : Node3D)

static func addItemPickup(inSource : Node3D, inItem : Item) -> void:
	var level : Level = Game.getGame(inSource.get_tree()).getLevel()
	level.getEnvironmentEventBus().item_picked_up.emit(inSource, inItem)

static func addEnvironmentSound(inSource : Node3D) -> void:
	var level : Level = Game.getGame(inSource.get_tree()).getLevel()
	level.getEnvironmentEventBus().sound_triggered.emit(inSource)

static func addDamageEvent(inSource : Node3D, inTarget : Node3D) -> void:
	var level : Level = Game.getGame(inSource.get_tree()).getLevel()
	level.getEnvironmentEventBus().damage_event.emit(inSource, inTarget)
