extends Node
class_name PlayerRecoilController

@export_category("Ref")
@export var recoilPunch : Punch

func _ready() -> void:
	assert(recoilPunch)

func addRecoilRotationPunch(inPunch : Vector3) -> void:
	recoilPunch.addRotationPunch(inPunch)

func addRecoilTranslationPunch(inPunch : Vector3) -> void:
	recoilPunch.addTranslationPunch(inPunch)
