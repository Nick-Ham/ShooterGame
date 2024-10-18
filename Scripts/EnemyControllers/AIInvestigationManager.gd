extends Node
class_name AIInvestigationManager

class Investigation extends RefCounted:
	var investigationSource : Node3D = null
	var positionOfInterest : Vector3 = Vector3()

var remainingInvestigations : Array[Investigation]

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)

func _ready() -> void:
	Util.safeConnect(targeter.target_acquired, on_target_acquired)
	Util.safeConnect(targeter.target_lost, on_target_lost)

func hasInvestigations() -> bool:
	return !remainingInvestigations.is_empty()

func getCurrentInvestigation() -> Investigation:
	return remainingInvestigations.back()

func completeCurrentInvestigation() -> void:
	remainingInvestigations.pop_back()

func on_target_lost(inTarget : Node3D, inLossReason : LOSTracker.LossReason) -> void:
	if inLossReason == LOSTracker.LossReason.DESTRUCTION:
		return

	var newInvestigation : Investigation = Investigation.new()
	newInvestigation.investigationSource = inTarget
	newInvestigation.positionOfInterest = inTarget.global_position
	remainingInvestigations.append(newInvestigation)

func on_target_acquired(inTarget : Node3D) -> void:
	var investigationsToRemove : Array[Investigation] = []
	for investigation : Investigation in remainingInvestigations:
		if investigation.investigationSource == inTarget:
			investigationsToRemove.append(investigation)

	for investigation : Investigation in investigationsToRemove:
		remainingInvestigations.erase(investigation)
