extends Node
class_name WeaponState

var stateKey : String = ""

signal request_change_state(inStateKey : String)

func getStateKey() -> String:
	return ""

func stateEntering() -> void:
	return

func stateExiting() -> void:
	return

func handleOnShootChanged(_inIsShooting : bool) -> void:
	return

func handleOnReloadChanged(_inIsReloading : bool) -> void:
	return

func getStateManager() -> WeaponStateManager:
	return get_parent() as WeaponStateManager

func getCurrentBloomValue() -> float:
	return 0.0
