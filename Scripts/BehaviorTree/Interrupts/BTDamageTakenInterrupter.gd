extends Node
class_name BTDamageTakenInterrupter

var healthNodes : Array[Health]

@onready var emptyShootPattern : Resource = preload("res://Data/ShootPatterns/StopShooting.tres")

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)

func _ready() -> void:
	var level : Level = Game.getGame(get_tree()).getLevel()
	var environmentalEventBus : EnvironmentEventBus = Util.getChildOfType(level, EnvironmentEventBus)

	Util.safeConnect(environmentalEventBus.damage_event, on_damage_event)

func on_damage_event(inSource : Node3D, inTarget : Node3D) -> void:
	var targetCharacter : Character = inTarget as Character
	if !targetCharacter:
		return

	if !targetCharacter == owningCharacter:
		return

	var sourceCharacter : Character = inSource as Character
	if !sourceCharacter:
		return

	if owningCharacter.team == sourceCharacter.team:
		return

	targeter.acquireTarget(sourceCharacter)

	var behaviorTree : BehaviorTree = get_parent() as BehaviorTree
	behaviorTree.interrupt()
