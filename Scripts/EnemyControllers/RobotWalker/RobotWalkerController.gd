extends AIController
class_name RobotWalkerController

var player : Character = null

func _ready() -> void:
	super._ready()

	var game : Game = Game.getGame(get_tree())
	player = game.getLevel().getPlayerCharacter()

	target = player
