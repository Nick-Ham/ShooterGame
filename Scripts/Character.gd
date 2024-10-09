extends CharacterBody3D
class_name Character

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
