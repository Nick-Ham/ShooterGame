extends Node
class_name PlayerSoundController

@export_category("Ref")
@export var stateManager : CharacterStateManager
@export var headBob : HeadBob
@export var groundShapeCast : ShapeCast3D

@export var jumpStreamPlayer : AudioStreamPlayer3D
@export var landingStreamPlayer : AudioStreamPlayer3D
@export var stepStreamPlayer : AudioStreamPlayer3D

func _ready() -> void:
	assert(stateManager)
	assert(headBob)
	assert(groundShapeCast)

	assert(jumpStreamPlayer)
	assert(landingStreamPlayer)
	assert(stepStreamPlayer)


	Util.safeConnect(headBob.step_taken, on_step_taken)
	Util.safeConnect(stateManager.state_changed, on_state_changed)

func on_state_changed(lastState : CharacterState, newState : CharacterState) -> void:
	if newState is CharacterStateJumping:
		var footstepPattern : FootstepPattern = getFootstepPattern()
		jumpStreamPlayer.stream = footstepPattern.jumpingAudioStream
		jumpStreamPlayer.play()

	if lastState is CharacterStateInAir and newState is CharacterStateDefault:
		var footstepPattern : FootstepPattern = getFootstepPattern()
		landingStreamPlayer.stream = footstepPattern.landingAudioStream
		landingStreamPlayer.play()

func on_step_taken(_isLeft : bool) -> void:
	var footstepPattern : FootstepPattern = getFootstepPattern()
	stepStreamPlayer.stream = footstepPattern.stepAudioStream
	stepStreamPlayer.play()

func getFootstepPattern() -> FootstepPattern:
	return FootstepPatternDataLibrary.getMaterialFootstep(getGroundMaterial())

func getGroundMaterial() -> FootstepPatternDataLibrary.MaterialType:
	if !groundShapeCast.is_colliding():
		return FootstepPatternDataLibrary.MaterialType.DEFAULT

	var collider : Node = groundShapeCast.get_collider(0)
	var stepMaterialProvider : StepMaterialProvider = Util.getChildOfType(collider, StepMaterialProvider)

	if !is_instance_valid(stepMaterialProvider):
		return FootstepPatternDataLibrary.MaterialType.DEFAULT

	return stepMaterialProvider.getMaterialType()
