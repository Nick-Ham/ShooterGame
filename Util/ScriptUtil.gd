extends Node
class_name Util

static func safeConnect(inSignal : Signal, inCallable : Callable) -> void:
	if inSignal.is_connected(inCallable):
		inSignal.disconnect(inCallable)
	inSignal.connect(inCallable)
