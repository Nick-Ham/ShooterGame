extends Node
class_name StepMaterialProvider

@export_category("Config")
@export var materialType : FootstepPatternDataLibrary.MaterialType

func getMaterialType() -> FootstepPatternDataLibrary.MaterialType:
	return materialType
