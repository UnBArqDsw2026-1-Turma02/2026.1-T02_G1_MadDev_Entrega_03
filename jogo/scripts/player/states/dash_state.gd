## State Pattern — estado Dash: player em deslocamento rápido por tempo fixo.
##
## O timer de duração é interno ao estado (sem await / Coroutine).
## O cooldown é disparado via player.start_dash_cooldown() no exit(),
## mantendo a responsabilidade de tempo no player mas sem bloquear a FSM.
##
## Transições possíveis:
##   → Move : ao fim do dash, se ainda houver input de movimento
##   → Idle : ao fim do dash, sem input de movimento
extends PlayerState
class_name DashState
 
 
# Timer interno que conta o tempo decorrido dentro do dash
var _elapsed: float = 0.0
 
# Direção capturada no momento do enter (não relida durante o dash)
var _dash_dir: Vector2 = Vector2.ZERO
 
 
func enter(player: CharacterBody2D) -> void:
	_elapsed = 0.0
 
	# Captura a direção: prioriza input atual, cai para última direção conhecida,
	# e usa RIGHT como fallback absoluto (nunca dash para Vector2.ZERO).
	_dash_dir = player.get_move_input()
	if _dash_dir == Vector2.ZERO:
		_dash_dir = player.last_move_dir
	if _dash_dir == Vector2.ZERO:
		_dash_dir = Vector2.RIGHT
 
	player.velocity = _dash_dir * player.dash_speed
	player._can_dash = false
 
 
func update(delta: float, player: CharacterBody2D) -> void:
	_elapsed += delta
	# Mantém a velocidade do dash — não relê o input para garantir
	# que o dash seja sempre na direção original.
	player.velocity = _dash_dir * player.dash_speed
 
 
func exit(player: CharacterBody2D) -> void:
	# Dispara o cooldown no player sem bloquear a FSM com await
	player.start_dash_cooldown()
 
 
func get_transition(player: CharacterBody2D) -> StringName:
	if _elapsed >= player.dash_duration:
		return STATE_MOVE if player.get_move_input() != Vector2.ZERO else STATE_IDLE
	return STATE_NONE
