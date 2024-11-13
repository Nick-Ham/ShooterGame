extends Node
class_name LevelEventHandler

var deathScreenScene : PackedScene = preload("res://Scenes/UI/DeathScreen.tscn")

func on_player_destroyed(_inPlayer : Character) -> void:
	var deathScreenInstance : DeathScreen = deathScreenScene.instantiate()
	deathScreenInstance.initializeMenu(get_tree())
