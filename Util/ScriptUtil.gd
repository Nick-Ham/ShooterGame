extends Object
class_name Util

static func safeConnect(inSignal : Signal, inCallable : Callable) -> void:
	if inSignal.is_connected(inCallable):
		inSignal.disconnect(inCallable)
	inSignal.connect(inCallable)

static func getChildOfType(inParent : Node, inType : Script) -> Node:
	if !is_instance_valid(inParent):
		return null

	for child : Node in inParent.get_children():
		var instanceOf : bool = is_instance_of(child, inType)
		if is_instance_of(child, inType):
			return child

	return null

static func getChildrenOfType(inParent : Node, inType : Script) -> Array[Node]:
	var foundChildren : Array[Node]
	for child : Node in inParent.get_children():
		if is_instance_of(child, inType):
			foundChildren.append(child)

	return foundChildren

static func getChildrenRecursive(inParent : Node) -> Array[Node]:
	var foundChildren : Array[Node]
	var nodesToSearch : Array[Node] = [inParent]

	while !nodesToSearch.is_empty():
		var nodeToSearch : Node = nodesToSearch.pop_back()

		var children : Array[Node] = nodeToSearch.get_children()
		nodesToSearch.append_array(children)
		foundChildren.append_array(children)

	return foundChildren

static func isValid(inObject : Variant) -> bool:
	return is_instance_valid(inObject) and !inObject.is_queued_for_deletion()

static func getParentInTreeOfType(inNode : Node, inType : Script) -> Node:
	var node : Node = inNode

	while !is_instance_of(node, inType):
		if node == inNode.get_tree().root:
			return null

		node = node.get_parent()

	return node
