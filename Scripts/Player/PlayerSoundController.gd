extends Node
class_name PlayerSoundController

@export_category("Config")
@export var stateManager : CharacterStateManager
@export var jumpStreamPlayer : AudioStreamPlayer3D
@export var landingStreamPlayer : AudioStreamPlayer3D

func _ready() -> void:
	assert(stateManager)
	assert(jumpStreamPlayer)

	Util.safeConnect(stateManager.state_changed, on_state_changed)

func on_state_changed(lastState : CharacterState, newState : CharacterState) -> void:
	if newState is CharacterStateJumping:
		jumpStreamPlayer.play()

	if lastState is CharacterStateInAir and newState is CharacterStateDefault:
		landingStreamPlayer.play()
