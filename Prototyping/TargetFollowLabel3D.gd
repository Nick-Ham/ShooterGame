extends Label3D
class_name TargetFollowLabel3D

@export_category("Ref")
@export var target : Node3D

@export_category("Config")
@export var trackPlayer : bool = true

func _ready() -> void:
	if !trackPlayer:
		return

	var game : Game = Game.getGame(get_tree())
	var level : Level = game.getLevel()
	var player : Character = level.getPlayerCharacter()

	target = player

func setText(inText : String) -> void:
	text = inText

func _physics_process(_delta: float) -> void:
	if !target:
		return

	var targetPosition : Vector3 = target.global_position

	var targetAsCharacter : Character = target as Character
	if targetAsCharacter:
		targetPosition = targetAsCharacter.getHeadGlobalPosition()

	look_at(targetPosition, Vector3.UP, true)
