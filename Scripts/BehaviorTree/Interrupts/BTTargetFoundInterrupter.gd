extends Node
class_name BTTargetFoundInterrupter

@onready var emptyShootPattern : Resource = preload("res://Data/ShootPatterns/StopShooting.tres")

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)
@onready var shootController : AIShootController = Util.getChildOfType(owningCharacter, AIShootController)

func _ready() -> void:
	Util.safeConnect(targeter.target_acquired, on_target_acquired)
	Util.safeConnect(targeter.target_lost, on_target_lost)

func on_target_acquired(_inTarget : Node3D) -> void:
	var behaviorTree : BehaviorTree = get_parent() as BehaviorTree
	behaviorTree.interrupt()

func on_target_lost(_inTarget : Node3D, _inLossReason : LOSTracker.LossReason) -> void:
	return
	#shootController.addPattern(emptyShootPattern)

	#var behaviorTree : BehaviorTree = get_parent() as BehaviorTree
	#behaviorTree.interrupt()
