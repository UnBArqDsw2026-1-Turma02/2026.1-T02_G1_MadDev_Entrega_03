## Object Pool Pattern — enable()/disable() permitem reusar instâncias sem queue_free().
## Bridge Pattern   — lógica de dano separada da representação visual (Sprite2D).
## Conexões de sinais (ex: body_entered → aplica dano) devem ser feitas via inspetor.
extends Area2D

# ---------------------------------------------------------------------------
# Atributos
# ---------------------------------------------------------------------------
@export var speed: float = 300.0
@export var damage: int = 10
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.RIGHT

var _elapsed: float = 0.0


# ---------------------------------------------------------------------------
# Object Pool — interface pública de ativação/desativação
# ---------------------------------------------------------------------------
func enable(spawn_position: Vector2, spawn_direction: Vector2) -> void:
	global_position = spawn_position
	direction = spawn_direction.normalized()
	_elapsed = 0.0
	show()
	set_process(true)
	monitoring = true
	monitorable = true


func disable() -> void:
	hide()
	set_process(false)
	monitoring = false
	monitorable = false


# ---------------------------------------------------------------------------
# Movimento e lifetime
# ---------------------------------------------------------------------------
func _ready() -> void:
	disable()


func _process(delta: float) -> void:
	position += direction * speed * delta
	_elapsed += delta
	if _elapsed >= lifetime:
		disable()


# ---------------------------------------------------------------------------
# Colisão — conecte body_entered ou area_entered via inspetor
# ---------------------------------------------------------------------------
func apply_damage_to(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)
	disable()
