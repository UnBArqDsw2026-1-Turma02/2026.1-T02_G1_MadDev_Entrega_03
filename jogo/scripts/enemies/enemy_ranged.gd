## Factory/Strategy Pattern — inimigo de longa distância.
## Sobrescreve _get_move_direction() para manter distância do player (Strategy).
## Dispara projéteis via Object Pool sem criar/destruir nós.
class_name EnemyRanged
extends EnemyBase

# ---------------------------------------------------------------------------
# Configuração exportada
# ---------------------------------------------------------------------------
@export var shoot_interval: float = 2.0
@export var preferred_distance: float = 150.0

# ---------------------------------------------------------------------------
# Estado interno
# ---------------------------------------------------------------------------
var _shoot_timer: float = 0.0
var _player: Node2D = null
var _pool: ProjectilePool = null


# ---------------------------------------------------------------------------
# Lifecycle
# ---------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	_player = get_tree().get_first_node_in_group("player") as Node2D
	var pools := get_tree().get_nodes_in_group("projectile_pool")
	if pools.size() > 0:
		_pool = pools[0] as ProjectilePool


# ---------------------------------------------------------------------------
# Strategy — mantém distância preferida do player
# ---------------------------------------------------------------------------
func _get_move_direction() -> Vector2:
	if _player == null:
		return Vector2.ZERO
	var dist: float = global_position.distance_to(_player.global_position)
	var to_player: Vector2 = global_position.direction_to(_player.global_position)
	if dist > preferred_distance:
		return to_player
	elif dist < preferred_distance * 0.7:
		return -to_player
	return Vector2.ZERO


# ---------------------------------------------------------------------------
# Disparo — acumula timer e dispara via pool
# ---------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if _is_dead:
		return
	_shoot_timer += delta
	if _shoot_timer >= shoot_interval and _player != null and _pool != null:
		_shoot_timer = 0.0
		_shoot()
	super._physics_process(delta)


func _shoot() -> void:
	var dir: Vector2 = global_position.direction_to(_player.global_position)
	_pool.get_projectile(global_position, dir, self)
