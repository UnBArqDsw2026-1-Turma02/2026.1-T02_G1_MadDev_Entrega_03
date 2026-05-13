## Visitor Pattern  — aceita um RoomValidator que verifica se pode ser destrancada.
## Observer Pattern — emite SignalBus.door_lock_changed; conexões via inspetor.
## Strategy Pattern — o critério de desbloqueio pode ser trocado sem mudar esta classe.
extends StaticBody2D

@export var door_id: String = "door_default"
@export var starts_locked: bool = false

var is_locked: bool = false

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	if starts_locked:
		lock()
	else:
		unlock()


# ---------------------------------------------------------------------------
# Interface pública de travamento
# ---------------------------------------------------------------------------
func lock() -> void:
	is_locked = true
	collision.disabled = false
	SignalBus.door_lock_changed.emit(door_id, true)


func unlock() -> void:
	is_locked = false
	collision.disabled = true
	SignalBus.door_lock_changed.emit(door_id, false)


func toggle() -> void:
	if is_locked:
		unlock()
	else:
		lock()


# ---------------------------------------------------------------------------
# Visitor Pattern — aceita um visitante que decide se pode destravar
# ---------------------------------------------------------------------------
func accept(visitor: Object) -> void:
	if visitor.has_method("visit_door"):
		visitor.visit_door(self)
