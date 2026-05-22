## State Pattern — estado Move: player se deslocando com input direcional.
##
## Transições possíveis:
##   → Idle  : ao soltar todas as teclas de movimento
##   → Dash  : ao pressionar dash (se cooldown disponível)
extends PlayerState
class_name MoveState
 
 
func enter(_player: CharacterBody2D) -> void:
	pass
 
 
func update(_delta: float, player: CharacterBody2D) -> void:
	var dir: Vector2 = player.get_move_input()
	player.velocity = dir * player.move_speed
 
	# Atualiza a última direção conhecida para o DashState usar quando
	# o jogador aciona o dash sem estar se movendo naquele frame exato.
	if dir != Vector2.ZERO:
		player.last_move_dir = dir
 
 
func exit(_player: CharacterBody2D) -> void:
	pass
 
 
func get_transition(player: CharacterBody2D) -> StringName:
	# Prioridade: Dash > Idle
	if player.is_dash_just_pressed() and player.can_dash():
		return STATE_DASH
	if player.get_move_input() == Vector2.ZERO:
		return STATE_IDLE
	return STATE_NONE
