extends Node
class_name Util

static func safeConnect(inSignal : Signal, inCallable : Callable) -> void:
	if inSignal.is_connected(inCallable):
		inSignal.disconnect(inCallable)
	inSignal.connect(inCallable)

static func getChildOfType(inParent : Node, inType : Script) -> Node:
	for child : Node in inParent.get_children():
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
