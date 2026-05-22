## Factory/Prototype Pattern  — classe base de todos os inimigos.
## Strategy Pattern           — movimento delegado a move_strategy (composição).
##                              Troque a estratégia no inspetor sem alterar este script.
## Observer Pattern           — emite eventos via GameMediator.
## Chain of Responsibility    — take_damage() será o ponto de entrada da cadeia de dano.
extends CharacterBody2D
class_name EnemyBase
 
 
# ---------------------------------------------------------------------------
# Atributos base
# ---------------------------------------------------------------------------
@export var max_health: int    = 30
@export var resistance: int    = 0
@export var attack_damage: int = 5
@export var move_speed: float  = 60.0
 
 
# ---------------------------------------------------------------------------
# Strategy Pattern (#9) — estratégia de movimento intercambiável
# ---------------------------------------------------------------------------
## Define como este inimigo se move. Atribua no inspetor ou via código.
##
## Estratégias disponíveis (jogo/scripts/enemies/strategies/):
##   • DirectChaseStrategy   — linha reta ao player, sem desvio de obstáculos
##   • NavigationStrategy    — usa NavigationAgent2D para desviar de obstáculos
##   • PatrolStrategy        — cicla por pontos fixos, ignora o player
##
## Quando null, o comportamento cai para _get_move_direction() (herança),
## mantendo compatibilidade com inimigos concretos já existentes.
@export var move_strategy: MoveStrategy = null
 
 
# ---------------------------------------------------------------------------
# Referência ao alvo (player)
# ---------------------------------------------------------------------------
## Preenchido automaticamente em _ready() via grupo "player".
## Pode ser sobrescrito externamente (ex: GameMediator) se necessário.
var _target: Node2D = null
 
 
# ---------------------------------------------------------------------------
# Estado interno
# ---------------------------------------------------------------------------
var current_health: int = max_health
var _is_dead: bool      = false
 
 
# ---------------------------------------------------------------------------
# Lifecycle
# ---------------------------------------------------------------------------
func _ready() -> void:
	current_health = max_health
	_find_target()
 
 
## Localiza o player pelo grupo "player". Chamado uma vez em _ready().
## Adicione o nó do player ao grupo "player" nas propriedades do nó no editor.
func _find_target() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_target = players[0]
	else:
		push_warning(
			"EnemyBase '%s': nenhum nó no grupo 'player' encontrado. " \
			% name +
			"Adicione o player ao grupo 'player' para que os inimigos o sigam."
		)
 
 
# ---------------------------------------------------------------------------
# Física — Strategy primeiro, herança como fallback
# ---------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	if _is_dead:
		return
 
	if move_strategy != null:
		# Strategy Pattern: delega o cálculo de velocidade à estratégia ativa.
		# Troque move_strategy no inspetor para mudar o comportamento em tempo de execução.
		velocity = move_strategy.get_velocity(self, _target)
	else:
		# Fallback por herança: mantém compatibilidade com subclasses que
		# sobrescrevem _get_move_direction() sem usar uma MoveStrategy.
		velocity = _get_move_direction() * move_speed
 
	move_and_slide()
 
 
# ---------------------------------------------------------------------------
# Movimento por herança (fallback)
# ---------------------------------------------------------------------------
## Sobrescreva em subclasses que não usem move_strategy.
## Retorna a direção de movimento normalizada — a velocidade é multiplicada aqui.
func _get_move_direction() -> Vector2:
	return Vector2.ZERO
 
 
# ---------------------------------------------------------------------------
# Combate — ponto de entrada para Chain of Responsibility
# ---------------------------------------------------------------------------
func take_damage(amount: int) -> void:
	if _is_dead:
		return
	var damage: int = maxi(0, amount - resistance)
	current_health  = maxi(0, current_health - damage)
	if current_health == 0:
		_die()
 
 
func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	GameMediator.notify(self, GameMediator.EVENT_ENEMY_DIED, {"enemy": self})
	queue_free()
 
 
# ---------------------------------------------------------------------------
# Visitor Pattern (#10) — Double Dispatch
# ---------------------------------------------------------------------------
## Permite que um StatsVisitor colete dados deste inimigo sem que EnemyBase
## precise conhecer o visitor. O visitor recebe a instância concreta (self)
## e chama visit_enemy() com acesso a todos os atributos públicos.
func accept(visitor: StatsVisitor) -> void:
	visitor.visit_enemy(self)
