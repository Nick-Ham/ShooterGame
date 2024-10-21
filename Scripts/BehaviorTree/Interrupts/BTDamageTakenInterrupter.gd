extends Node
class_name BTDamageTakenInterrupter

var healthNodes : Array[Health]

@onready var emptyShootPattern : Resource = preload("res://Data/ShootPatterns/StopShooting.tres")

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)
@onready var shootController : AIShootController = Util.getChildOfType(owningCharacter, AIShootController)
@onready var investigationManager : AIInvestigationManager = Util.getChildOfType(owningCharacter, AIInvestigationManager)

func _ready() -> void:
	var nodes : Array[Node] = Util.getChildrenOfType(owningCharacter, Health)
	for node : Node in nodes:
		var nodeAsHealth : Health = node as Health
		if !nodeAsHealth:
			continue

		healthNodes.append(nodeAsHealth)


	for health : Health in healthNodes:
		Util.safeConnect(health.health_damaged, on_health_damaged)

func on_health_damaged(_damage : float, _newHealth : float) -> void:
	if targeter.hasTarget():
		return

	var behaviorTree : BehaviorTree = get_parent() as BehaviorTree
	behaviorTree.interrupt()
