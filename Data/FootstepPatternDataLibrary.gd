extends Node
class_name FootstepPatternDataLibrary

enum MaterialType {
	DEFAULT,
	METAL,
	GRAVEL,
	STONE
}

static var materialPatternMap : Dictionary = {
	MaterialType.DEFAULT : preload("res://Data/FootstepPatterns/DefaultFootstep.tres"),
	MaterialType.METAL : preload("res://Data/FootstepPatterns/MetalFootstep.tres"),
	MaterialType.GRAVEL : preload("res://Data/FootstepPatterns/DefaultFootstep.tres"),
	MaterialType.STONE : preload("res://Data/FootstepPatterns/DefaultFootstep.tres")
}

static func getMaterialFootstep(inMaterialType : MaterialType) -> FootstepPattern:
	return materialPatternMap[inMaterialType]
