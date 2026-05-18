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
	SignalBus.enemy_died.emit(self)
	queue_free()


# ---------------------------------------------------------------------------
# Movimento — Strategy Pattern: subclasses sobrescrevem _get_move_direction()
# ---------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if _is_dead:
		return
	
	# Movimento
	velocity = _get_move_direction() * move_speed
	move_and_slide()
	
	# Ataque (Template Method) - Adicione isso!
	attack_sequence()
	
	# Atualiza cooldown
	_update_cooldown(delta)


## Retorna a direção de movimento. Sobrescreva em cada inimigo concreto.
func _get_move_direction() -> Vector2:
	return Vector2.ZERO
	
	
# ---------------------------------------------------------------------------
# Template Method - Ataque dos inimigos
# ---------------------------------------------------------------------------

## Tempo de cooldown entre ataques (segundos)
@export var attack_cooldown_time: float = 1.0
var _attack_cooldown_remaining: float = 0.0


## Template Method - Define a sequência fixa do ataque
func attack_sequence() -> void:
	# Se está em cooldown, não ataca
	if _attack_cooldown_remaining > 0:
		print("  Em cooldown: ", _attack_cooldown_remaining)  # DEBUG
		return
	
	# Passo 1: Verifica se pode atacar
	if not can_attack():
		print("  cannot_attack retornou false")  # DEBUG
		return
		
	prepare_attack()
	execute_attack()
	cooldown()


## Verifica se o inimigo pode atacar (distância, visão, etc)
## Sobrescreva em classes filhas para comportamentos específicos
func can_attack() -> bool:
	# Padrão: sempre pode atacar (exceto se estiver morto)
	return not _is_dead


## Prepara o ataque (animação, efeito sonoro, etc)
## Sobrescreva em classes filhas se necessário
func prepare_attack() -> void:
	# Padrão: não faz nada
	pass


## Executa o ataque (aplica dano ao jogador)
## Sobrescreva em classes filhas para ataques específicos
func execute_attack() -> void:
	# Padrão: ataque básico
	_apply_damage_to_player(attack_damage)


## Inicia o cooldown do ataque
func cooldown() -> void:
	_attack_cooldown_remaining = attack_cooldown_time


## Aplica dano ao jogador (método auxiliar)
func _apply_damage_to_player(damage_amount: int) -> void:
	# Encontra o jogador na cena
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("take_damage"):
		player.take_damage(damage_amount)
		print(name, " atacou! Dano: ", damage_amount)


## Atualiza o cooldown a cada frame
func _update_cooldown(delta: float) -> void:
	if _attack_cooldown_remaining > 0:
		_attack_cooldown_remaining -= delta


## Sobrescrever _process para atualizar cooldown
func _process(delta: float) -> void:
	_update_cooldown(delta)
