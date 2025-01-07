extends Node
class_name Interactable

signal interact_changed(inIsInteracting : bool)

func setIsInteracting(inIsInteracting : bool) -> void:
	interact_changed.emit(inIsInteracting)
