## Factory/Prototype Pattern — classe base de todos os inimigos.
## State Pattern   — subclasses implementarão estados de IA.
## Observer Pattern — emite sinais pelo SignalBus; conexões via inspetor.
## Chain of Responsibility — take_damage() será o ponto de entrada da cadeia de dano.
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
	_build_damage_chain()


# ---------------------------------------------------------------------------
# Combate — ponto de entrada para Chain of Responsibility
# ---------------------------------------------------------------------------
var damage_chain: DamageHandler

func _build_damage_chain() -> void:
	var armor_handler = ArmorHandler.new()
	var health_end = HealthHandler.new()
	
	armor_handler.armor_value = resistance
	armor_handler.next = health_end
	damage_chain = armor_handler

func take_damage(amount: int) -> void:
	if _is_dead:
		return
	
	var context = {"target": self}
	damage_chain.handle(amount, context)

func apply_final_damage(final_damage: int) -> void:
	current_health = maxi(0, current_health - final_damage)
	
	if current_health == 0:
		_die()


func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	SignalBus.enemy_died.emit(self)
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
