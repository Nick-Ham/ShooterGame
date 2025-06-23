extends Object
class_name BTUtil

static func isValidBlackboard(inBlackboard : Blackboard, varName : String, inType : Script = null) -> bool:
	if !inBlackboard.has_var(varName):
		return false

	var foundVar : Variant = inBlackboard.get_var(varName)

	if !is_instance_valid(foundVar):
		return false


	if inType != null:
		if !is_instance_of(foundVar, inType):
			return false

	return true
