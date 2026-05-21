## Factory/Prototype Pattern — classe base de todos os inimigos.
## State Pattern   — subclasses implementarão estados de IA.
## Observer Pattern — emite eventos via GameMediator.
## Chain of Responsibility — take_damage() será o ponto de entrada da cadeia de dano.
class_name EnemyBase
extends CharacterBody2D

# ---------------------------------------------------------------------------
# Atributos base
# ---------------------------------------------------------------------------
@export var max_health: int = 30
@export var resistance: int = 0
@export var attack_damage: int = 5
@export var move_speed: float = 60.0

var current_health: int = max_health
var _is_dead: bool = false


# ---------------------------------------------------------------------------
# Lifecycle
# ---------------------------------------------------------------------------
func _ready() -> void:
	current_health = max_health


# ---------------------------------------------------------------------------
# Combate — ponto de entrada para Chain of Responsibility
# ---------------------------------------------------------------------------
func take_damage(amount: int) -> void:
	if _is_dead:
		return
	var damage: int = maxi(0, amount - resistance)
	current_health = maxi(0, current_health - damage)
	if current_health == 0:
		_die()


func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	GameMediator.notify(self, GameMediator.EVENT_ENEMY_DIED, {"enemy": self})
	queue_free()


# ---------------------------------------------------------------------------
# Movimento — Strategy Pattern: subclasses sobrescrevem _get_move_direction()
# ---------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	if _is_dead:
		return
	velocity = _get_move_direction() * move_speed
	move_and_slide()


## Retorna a direção de movimento. Sobrescreva em cada inimigo concreto.
func _get_move_direction() -> Vector2:
	return Vector2.ZERO
