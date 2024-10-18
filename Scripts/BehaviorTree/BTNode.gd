extends Node
class_name BTNode

class BTTickResult extends RefCounted:
	var tickResult : TickResult = TickResult.FAILURE
	var nodeSource : BTNode = null

enum TickResult {
	SUCCESS,
	FAILURE,
	RUNNING
}

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)

func _ready() -> void:
	assert(owningCharacter)
	assert(targeter)

func updateNode(_inDelta : float) -> BTTickResult:
	return fail()

func succeed() -> BTTickResult:
	var result : BTTickResult = BTTickResult.new()
	result.nodeSource = self
	result.tickResult = TickResult.SUCCESS
	return result

func fail() -> BTTickResult:
	var result : BTTickResult = BTTickResult.new()
	result.nodeSource = self
	result.tickResult = TickResult.FAILURE
	return result

func run() -> BTTickResult:
	var result : BTTickResult = BTTickResult.new()
	result.nodeSource = self
	result.tickResult = TickResult.RUNNING
	return result

func isNodeActive() -> bool:
	var node : Node = self
	var parent : BehaviorTree = Util.getParentInTreeOfType(self, BehaviorTree) as BehaviorTree
	if !parent:
		push_error("BTNode used outside of BehaviorTree node.")
		return false

	if parent.getActiveNode() == self:
		return true

	return false
