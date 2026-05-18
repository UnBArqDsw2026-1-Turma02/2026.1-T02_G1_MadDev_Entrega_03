## Mediator Pattern - coordenador formal de comunicacao entre sistemas.
## Sistemas publicam eventos tipados e os interessados registram callbacks.
extends Node

const EVENT_PLAYER_HEALTH_CHANGED: StringName = &"player_health_changed"
const EVENT_PLAYER_DIED: StringName = &"player_died"
const EVENT_ENEMY_DIED: StringName = &"enemy_died"
const EVENT_ROOM_CLEARED: StringName = &"room_cleared"
const EVENT_RUN_STARTED: StringName = &"run_started"
const EVENT_RUN_ENDED: StringName = &"run_ended"
const EVENT_GAME_PAUSED: StringName = &"game_paused"
const EVENT_SCORE_CHANGED: StringName = &"score_changed"

var _handlers: Dictionary = {}


func _ready() -> void:
	_register_signal_bus_bridge()
	if OS.is_debug_build():
		assert(debug_test_unregister(), "GameMediator.unregister nao removeu o handler.")


func notify(sender: Object, event: StringName, data: Dictionary = {}) -> void:
	if not _handlers.has(event):
		return

	var callbacks: Array = _handlers[event].duplicate()
	for callback: Callable in callbacks:
		if callback.is_valid():
			callback.call(sender, event, data)


func register(event: StringName, callback: Callable) -> void:
	if not callback.is_valid():
		push_warning("GameMediator: callback invalido para evento '%s'." % event)
		return

	if not _handlers.has(event):
		_handlers[event] = []

	var callbacks: Array = _handlers[event]
	if not callbacks.has(callback):
		callbacks.append(callback)


func unregister(event: StringName, callback: Callable) -> void:
	if not _handlers.has(event):
		return

	var callbacks: Array = _handlers[event]
	callbacks.erase(callback)
	if callbacks.is_empty():
		_handlers.erase(event)


func debug_test_unregister() -> bool:
	var received_count: int = 0
	var callback := func(_sender: Object, _event: StringName, _data: Dictionary) -> void:
		received_count += 1

	register(&"debug_unregister_test", callback)
	notify(self, &"debug_unregister_test")
	unregister(&"debug_unregister_test", callback)
	notify(self, &"debug_unregister_test")
	return received_count == 1


func _register_signal_bus_bridge() -> void:
	register(EVENT_PLAYER_HEALTH_CHANGED, _emit_player_health_changed)
	register(EVENT_PLAYER_DIED, _emit_player_died)
	register(EVENT_ENEMY_DIED, _emit_enemy_died)
	register(EVENT_ROOM_CLEARED, _emit_room_cleared)
	register(EVENT_RUN_STARTED, _emit_run_started)
	register(EVENT_RUN_ENDED, _emit_run_ended)
	register(EVENT_GAME_PAUSED, _emit_game_paused)
	register(EVENT_SCORE_CHANGED, _emit_score_changed)


func _emit_player_health_changed(_sender: Object, _event: StringName, data: Dictionary) -> void:
	SignalBus.player_health_changed.emit(data.get("new_health", 0), data.get("max_health", 0))


func _emit_player_died(_sender: Object, _event: StringName, _data: Dictionary) -> void:
	SignalBus.player_died.emit()


func _emit_enemy_died(sender: Object, _event: StringName, data: Dictionary) -> void:
	var enemy: Node = data.get("enemy", sender) as Node
	if enemy != null:
		SignalBus.enemy_died.emit(enemy)


func _emit_room_cleared(_sender: Object, _event: StringName, _data: Dictionary) -> void:
	SignalBus.room_cleared.emit()


func _emit_run_started(_sender: Object, _event: StringName, _data: Dictionary) -> void:
	SignalBus.run_started.emit()


func _emit_run_ended(_sender: Object, _event: StringName, data: Dictionary) -> void:
	SignalBus.run_ended.emit(data.get("victory", false))


func _emit_game_paused(_sender: Object, _event: StringName, data: Dictionary) -> void:
	SignalBus.game_paused.emit(data.get("is_paused", false))


func _emit_score_changed(_sender: Object, _event: StringName, data: Dictionary) -> void:
	SignalBus.score_changed.emit(data.get("new_score", 0))
