extends Node
class_name MenuManager

var menuStack : Array[MenuBase]

var currentMenu : MenuBase

func addMenu(inMenu : MenuBase) -> void:
	if currentMenu:
		currentMenu.setMenuEnabled(false)
		menuStack.push_back(currentMenu)
		currentMenu = null

	currentMenu = inMenu
	add_child(currentMenu)
	configureMouseSettings()

func configureMouseSettings() -> void:
	var mouseMode : Input.MouseMode = Input.MOUSE_MODE_CAPTURED if currentMenu.capturesMouse else Input.MOUSE_MODE_VISIBLE
	Input.set_mouse_mode(mouseMode)
