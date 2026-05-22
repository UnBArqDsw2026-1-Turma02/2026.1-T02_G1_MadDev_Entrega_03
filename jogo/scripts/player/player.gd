## Command/Adapter Pattern — leitura de input separada da execução de movimento.
## Observer Pattern  — eventos publicados via GameMediator notificam sistemas interessados.
## Object Pool      — disparo de projéteis via ProjectilePool (sem instantiate/queue_free).
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
@export var resistance: float = 0.0

var current_health: int = max_health

# ---------------------------------------------------------------------------
# Object Pool — pool de projéteis do player
# ---------------------------------------------------------------------------
@export var projectile_pool: ProjectilePool
@export var shoot_cooldown: float = 0.3

var _shoot_timer: float = 0.0

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
	add_to_group("player")
	current_health = max_health
	SignalBus.player_health_changed.emit(current_health, max_health)


func _physics_process(delta: float) -> void:
	if _is_dashing:
		move_and_slide()
		return

	_move_direction = _read_move_input()
	velocity = _move_direction * move_speed

	if _read_dash_input() and _can_dash:
		_execute_dash()

	if _shoot_timer > 0.0:
		_shoot_timer -= delta

	if _read_shoot_input() and _shoot_timer <= 0.0:
		_shoot()

	move_and_slide()


# ---------------------------------------------------------------------------
# Adapter — leitura de input isolada (troca por outro InputAdapter no futuro)
# ---------------------------------------------------------------------------
func _read_move_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _read_dash_input() -> bool:
	return Input.is_action_just_pressed("dash")


func _read_shoot_input() -> bool:
	return Input.is_action_pressed("shoot")


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
# Object Pool — disparo via pool de projéteis na direção do mouse
# ---------------------------------------------------------------------------
func _shoot() -> void:
	if projectile_pool == null:
		return
	var dir: Vector2 = (get_global_mouse_position() - global_position).normalized()
	projectile_pool.get_projectile(global_position, dir, self)
	_shoot_timer = shoot_cooldown


# ---------------------------------------------------------------------------
# Vida (Observer via sinais)
# ---------------------------------------------------------------------------
@export var damage_chain: DamageHandler

# Sua função atualizada para usar a cadeia
func take_damage(amount: int) -> void:
	if not damage_chain:
		apply_final_damage(amount)
		return
		
	var context = {"target": self}
	damage_chain.handle(amount, context)

func apply_final_damage(final_damage: int) -> void:
	current_health = maxi(0, current_health - final_damage)
	
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
