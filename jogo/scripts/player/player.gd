## Command/Adapter Pattern — leitura de input separada da execução de movimento.
## Observer Pattern  — sinais health_changed e died notificam a UI sem acoplamento direto.
## Conexões de sinais devem ser feitas via inspetor.
extends CharacterBody2D

# ---------------------------------------------------------------------------
# Atributos de movimento
# ---------------------------------------------------------------------------
@export var move_speed: float = 200.0
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 1.0

# ---------------------------------------------------------------------------
# Atributos de combate / vida
# ---------------------------------------------------------------------------
@export var max_health: int = 100
@export var base_damage: int = 10
@export var defense: int = 0

var current_health: int = max_health

# ---------------------------------------------------------------------------
# Slots de equipamento (Decorator / Iterator)
# Cada slot guarda o Resource do item equipado, ou null se vazio.
# ---------------------------------------------------------------------------
enum EquipSlot { HEAD, TORSO, LEG, FOOT, ACCESSORY }

var equipment: Dictionary = {
	EquipSlot.HEAD:      null,
	EquipSlot.TORSO:     null,
	EquipSlot.LEG:       null,
	EquipSlot.FOOT:      null,
	EquipSlot.ACCESSORY: null,
}

# ---------------------------------------------------------------------------
# Estado interno de movimento
# ---------------------------------------------------------------------------
var _move_direction: Vector2 = Vector2.ZERO
var _is_dashing: bool = false
var _can_dash: bool = true


# ---------------------------------------------------------------------------
# Lifecycle
# ---------------------------------------------------------------------------
func _ready() -> void:
	current_health = max_health


func _physics_process(_delta: float) -> void:
	if _is_dashing:
		move_and_slide()
		return

	_move_direction = _read_move_input()
	velocity = _move_direction * move_speed

	if _read_dash_input() and _can_dash:
		_execute_dash()

	move_and_slide()


# ---------------------------------------------------------------------------
# Adapter — leitura de input isolada (troca por outro InputAdapter no futuro)
# ---------------------------------------------------------------------------
func _read_move_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _read_dash_input() -> bool:
	return Input.is_action_just_pressed("dash")


# ---------------------------------------------------------------------------
# Command — execução do dash isolada da leitura de input
# ---------------------------------------------------------------------------
func _execute_dash() -> void:
	var dir: Vector2 = _move_direction if _move_direction != Vector2.ZERO else Vector2.RIGHT
	_is_dashing = true
	_can_dash = false
	velocity = dir * dash_speed
	await get_tree().create_timer(dash_duration).timeout
	_is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	_can_dash = true


# ---------------------------------------------------------------------------
# Vida (Observer via sinais)
# ---------------------------------------------------------------------------
func take_damage(amount: int) -> void:
	var damage: int = maxi(0, amount - defense)
	current_health = maxi(0, current_health - damage)
	GameMediator.notify(self, GameMediator.EVENT_PLAYER_HEALTH_CHANGED, {
		"new_health": current_health,
		"max_health": max_health,
	})
	if current_health == 0:
		_die()


func heal(amount: int) -> void:
	current_health = mini(max_health, current_health + amount)
	GameMediator.notify(self, GameMediator.EVENT_PLAYER_HEALTH_CHANGED, {
		"new_health": current_health,
		"max_health": max_health,
	})


func _die() -> void:
	GameMediator.notify(self, GameMediator.EVENT_PLAYER_DIED)


# ---------------------------------------------------------------------------
# Equipamento
# ---------------------------------------------------------------------------
func equip(slot: EquipSlot, item: Resource) -> void:
	equipment[slot] = item


func unequip(slot: EquipSlot) -> void:
	equipment[slot] = null


func get_equipped(slot: EquipSlot) -> Resource:
	return equipment[slot]
