extends CanvasLayer
class_name MenuBase

@export_category("Config")
@export var capturesMouse : bool = false

var isEnabled : bool = true

func initializeMenu(inTree : SceneTree) -> void:
	var game : Game = Game.getGame(inTree)
	var menuManager : MenuManager = game.getMenuManager()

	menuManager.addMenu(self)

	setMenuEnabled(true)

func setMenuEnabled(inIsEnabled : bool) -> void:
	isEnabled = inIsEnabled
	visible = isEnabled
