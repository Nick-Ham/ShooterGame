extends Node
class_name Game

@export_category("GameConfig")
@export var initialLevelScene : PackedScene

var currentLevel : Level = null
var currentLevelScene : PackedScene = null

## GameSystems
var menuManager : MenuManager = null

func _enter_tree() -> void:
	menuManager = MenuManager.new()
	add_child(menuManager)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("F1"):
		Game.getGame(get_tree()).resetCurrentLevel()

func _ready() -> void:
	changeLevel(initialLevelScene)

func changeLevel(inLevelScene : PackedScene) -> void:
	if is_instance_valid(currentLevel):
		currentLevel.queue_free()
		currentLevel = null
		currentLevelScene = null

	currentLevelScene = inLevelScene
	currentLevel = inLevelScene.instantiate()
	add_child(currentLevel)

func _process(_delta: float) -> void:
	return
	#print(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))

func getLevel() -> Level:
	return currentLevel

func resetCurrentLevel() -> void:
	changeLevel(currentLevelScene)

static func getGame(inTree : SceneTree) -> Game:
	return inTree.current_scene as Game

func getMenuManager() -> MenuManager:
	return menuManager
