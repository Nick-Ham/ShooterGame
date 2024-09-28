extends Node

var loggerView : DebugLoggerView

func injectLoggerView(inLoggerView : DebugLoggerView) -> void:
	loggerView = inLoggerView

func registerTrackedValue(inKey : String) -> void:
	if loggerView == null:
		return

	loggerView.registerTrackedValue(inKey)

func updateTrackedValue(inKey : String, inValue : String) -> void:
	if loggerView == null:
		return

	loggerView.updateTrackedValue(inKey, inValue)

func unregisterTrackedValue(inKey : String) -> void:
	if loggerView == null:
		return

	loggerView.unregisterTrackedValue(inKey)

func setTrackedValueEnabled(inKey : String, inIsEnabled : bool) -> void:
	if loggerView == null:
		return

	loggerView.setTrackedValueEnabled(inKey, inIsEnabled)
