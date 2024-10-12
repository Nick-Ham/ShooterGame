extends CharacterBody3D
class_name Character

@export_category("CharacterConfig")
@export var headHeight : float = 1.5

func getHeadHeight() -> float:
	return headHeight

func getHeadGlobalPosition() -> Vector3:
	var headPosition : Vector3 = global_position
	headPosition.y += getHeadHeight()
	return headPosition

static func getOwningCharacter(inNode : Node) -> Character:
	if inNode == null:
		return null

	var currentParent : Node = inNode.get_parent()
	while currentParent != inNode.get_tree().root:
		currentParent = currentParent.get_parent()

		var asCharacter : Character = currentParent as Character
		if is_instance_valid(asCharacter):
			break

	return currentParent
