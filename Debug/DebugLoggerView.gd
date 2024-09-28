extends CanvasLayer
class_name DebugLoggerView

@export_category("Config")
@export var vBox : VBoxContainer

class TrackedValue:
	var name : String = ""
	var value : String = ""
	var isEnabled : bool = true

	func _init(inTrackedValueName : String) -> void:
		name = inTrackedValueName

var trackedValues : Array[TrackedValue]

func _enter_tree() -> void:
	# prototyping tech-debt
	DebugLogger.injectLoggerView(self)
	#

	registerTrackedValue("DebugLogger")
	updateTrackedValue("DebugLogger", "enabled")

func _ready() -> void:
	assert(vBox, "Must have a vBox reference set in order to function. " + String(self.name))

func refreshView() -> void:
	var childLabels : Array = vBox.get_children()

	for i : int in childLabels.size():
		var currentLabel : Label = childLabels[i] as Label
		var currentTrackedValue : TrackedValue = trackedValues[i]
		currentLabel.text = currentTrackedValue.name + ": " + currentTrackedValue.value
		currentLabel.visible = currentTrackedValue.isEnabled

func registerTrackedValue(inTrackedValueName : String) -> void:
	if getTrackedValue(inTrackedValueName):
		push_warning("Attempted to register a previously registered key in ", String(self.name))
		return

	var newTrackedValue : TrackedValue = TrackedValue.new(inTrackedValueName)

	trackedValues.append(newTrackedValue)

	var newLabel : Label = Label.new()
	vBox.add_child(newLabel)

	refreshView()

func updateTrackedValue(inTrackedValueName : String, inNewValue : String) -> void:
	var trackedValue : TrackedValue = getTrackedValue(inTrackedValueName)
	if trackedValue == null:
		push_warning("Attempted to update an unregistered TrackedValue. ", String(self.name))
		return

	trackedValue.value = inNewValue

	refreshView()

func setTrackedValueEnabled(inTrackedValueName : String, inIsEnabled : bool) -> void:
	var trackedValue : TrackedValue = getTrackedValue(inTrackedValueName)
	if trackedValue == null:
		push_warning("Attempted to set enabled on an unregistered TrackedValue. ", String(self.name))

	trackedValue.isEnabled = inIsEnabled

	refreshView()

func getTrackedValue(inTrackedValueName : String) -> TrackedValue:
	for trackedValue : TrackedValue in trackedValues:
		if inTrackedValueName == trackedValue.name:
			return trackedValue

	return null

func unregisterTrackedValue(inTrackedValueName : String) -> void:
	var trackedValue : TrackedValue = getTrackedValue(inTrackedValueName)
	if trackedValue == null:
		push_warning("Attempted to set unregister on an unregistered TrackedValue. ", String(self.name))

	trackedValues.erase(trackedValue)
	var children : Array[Node] = vBox.get_children()
	var label : Label = children.pop_back() as Label
	label.queue_free()

	refreshView()
