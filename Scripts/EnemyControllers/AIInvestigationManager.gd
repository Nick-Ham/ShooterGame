extends Node
class_name AIInvestigationManager

class Investigation extends RefCounted:
	var investigationSource : Node3D = null
	var positionOfInterest : Vector3 = Vector3()

var remainingInvestigations : Array[Investigation]

var currentInvestigation : Investigation = null

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)

func _ready() -> void:
	Util.safeConnect(targeter.target_acquired, on_target_acquired)
	Util.safeConnect(targeter.target_lost, on_target_lost)

func hasInvestigations() -> bool:
	return !remainingInvestigations.is_empty() || currentInvestigation

func getCurrentInvestigation() -> Investigation:
	if !currentInvestigation:
		currentInvestigation = remainingInvestigations.pop_back()

	return currentInvestigation

func completeCurrentInvestigation() -> void:
	currentInvestigation = null

func on_target_lost(inTarget : Node3D, inLossReason : LOSTracker.LossReason) -> void:
	if inLossReason == LOSTracker.LossReason.DESTRUCTION:
		return

	createInvestigation(inTarget)

func createPriorityInvestigation(inTarget : Node3D) -> void:
	var newInvestigation : Investigation = Investigation.new()
	newInvestigation.investigationSource = inTarget
	newInvestigation.positionOfInterest = inTarget.global_position

	if currentInvestigation:
		remainingInvestigations.append(currentInvestigation)
		currentInvestigation = null

	currentInvestigation = newInvestigation

func createInvestigation(inTarget : Node3D) -> void:
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

	if currentInvestigation and currentInvestigation.investigationSource == inTarget:
		currentInvestigation = null
