## Adapter Pattern  — toda leitura de input passa pelo InputAdapter; player nunca
##                    chama Input diretamente.
## State Pattern     — comportamento de movimento gerenciado pela FSM (_current_state).
##                    Adicionar/alterar um estado não exige mexer em _physics_process.
## Observer Pattern  — eventos publicados via GameMediator notificam sistemas interessados.
extends CharacterBody2D
 
 
# ---------------------------------------------------------------------------
# Adapter de input (#7) — único ponto de entrada para leitura de controles
# ---------------------------------------------------------------------------
@onready var _input_adapter: InputAdapter = InputAdapter.new()
 
 
# ---------------------------------------------------------------------------
# Atributos de movimento
# ---------------------------------------------------------------------------
@export var move_speed: float    = 200.0
@export var dash_speed: float    = 600.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 1.0
 
 
# ---------------------------------------------------------------------------
# Atributos de combate / vida
# ---------------------------------------------------------------------------
@export var max_health: int  = 100
@export var base_damage: int = 10
@export var defense: int     = 0
 
var current_health: int = max_health
 
 
# ---------------------------------------------------------------------------
# Slots de equipamento
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
# FSM (#8) — estados e variáveis de suporte
# ---------------------------------------------------------------------------
## Dicionário StringName → PlayerState instanciado
var _states: Dictionary = {}
 
## Estado ativo no momento
var _current_state: PlayerState = null
 
## Última direção de movimento não-nula — usada pelo DashState quando o
## jogador aciona o dash sem input de movimento naquele frame.
var last_move_dir: Vector2 = Vector2.RIGHT
 
## Flag de cooldown do dash — lida pelos estados via can_dash()
var _can_dash: bool = true
 
 
# ---------------------------------------------------------------------------
# Lifecycle
# ---------------------------------------------------------------------------
func _ready() -> void:
	add_child(_input_adapter)
	current_health = max_health
	_setup_state_machine()
	SignalBus.player_health_changed.emit(current_health, max_health)
 
 
func _physics_process(delta: float) -> void:
	# 1. Delega o comportamento deste frame ao estado ativo
	_current_state.update(delta, self)
 
	# 2. Verifica se o estado quer transicionar
	var next: StringName = _current_state.get_transition(self)
	if next != PlayerState.STATE_NONE:
		_change_state(next)
 
	# 3. Aplica o movimento calculado pelo estado
	move_and_slide()
 
 
# ---------------------------------------------------------------------------
# FSM — setup e transições
# ---------------------------------------------------------------------------
func _setup_state_machine() -> void:
	_states[PlayerState.STATE_IDLE]   = IdleState.new()
	_states[PlayerState.STATE_MOVE]   = MoveState.new()
	_states[PlayerState.STATE_DASH]   = DashState.new()
	_states[PlayerState.STATE_ATTACK] = AttackState.new()
	_change_state(PlayerState.STATE_IDLE)
 
 
func _change_state(new_state_name: StringName) -> void:
	assert(_states.has(new_state_name), \
		"Player._change_state(): estado '%s' não encontrado no dicionário _states." % new_state_name)
 
	if _current_state != null:
		_current_state.exit(self)
 
	_current_state = _states[new_state_name]
	_current_state.enter(self)
 
 
# ---------------------------------------------------------------------------
# API pública para os estados (#8) — estados chamam estes métodos,
# nunca acessam o adapter ou Input diretamente.
# ---------------------------------------------------------------------------
 
## Retorna o vetor de movimento atual via InputAdapter.
func get_move_input() -> Vector2:
	return _input_adapter.poll_move_vector()
 
 
## Retorna true se o dash foi pressionado neste frame via InputAdapter.
func is_dash_just_pressed() -> bool:
	return _input_adapter.is_just_pressed(InputAdapter.ACTION_DASH)
 
 
## Retorna true se o dash está disponível (cooldown zerado).
func can_dash() -> bool:
	return _can_dash
 
 
## Inicia o cooldown do dash sem bloquear a FSM com await.
## Chamado por DashState.exit().
func start_dash_cooldown() -> void:
	_can_dash = false
	get_tree().create_timer(dash_cooldown).timeout.connect(
		func() -> void: _can_dash = true,
		CONNECT_ONE_SHOT
	)
 
 
# ---------------------------------------------------------------------------
# Adapter — leitura de input (#7)
# Mantidos como métodos privados para uso interno eventual fora da FSM.
# ---------------------------------------------------------------------------
func _read_move_input() -> Vector2:
	return _input_adapter.poll_move_vector()
 
 
func _read_dash_input() -> bool:
	return _input_adapter.is_just_pressed(InputAdapter.ACTION_DASH)
 
 
# ---------------------------------------------------------------------------
# Vida (Observer via sinais)
# ---------------------------------------------------------------------------
func take_damage(amount: int) -> void:
	var damage: int = maxi(0, amount - defense)
	current_health   = maxi(0, current_health - damage)
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
