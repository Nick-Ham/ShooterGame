extends Targeter
class_name AdvancedTargeter

func _ready() -> void:
	super._ready()

	Util.safeConnect(losTracker.character_lost, on_character_lost)

func on_character_lost(inCharacter : Character, inLossReason : LOSTracker.LossReason) -> void:
	return

	# Until a time when I feel like improving the ai, the advanced targeting will simply remain disabled

	#if !inCharacter == target:
		#return
#
	#if !target:
		#return
#
	#var currentInterest : TargetInterest = getInterest()
	#positionOfInterest = currentInterest.interestPosition
#
	#var previousTarget : Node3D = target
	#target = null
	#target_lost.emit(previousTarget, inLossReason)
