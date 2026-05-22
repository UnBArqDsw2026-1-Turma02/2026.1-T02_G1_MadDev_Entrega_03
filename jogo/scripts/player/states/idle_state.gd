## State Pattern — estado Idle: player parado, sem input de movimento.
##
## Transições possíveis:
##   → Move  : ao detectar input de movimento
##   → Dash  : ao pressionar dash (se cooldown disponível)
extends PlayerState
class_name IdleState
 
 
func enter(player: CharacterBody2D) -> void:
	# Zera a velocidade ao entrar em Idle para evitar deslizamento
	player.velocity = Vector2.ZERO
 
 
func update(_delta: float, player: CharacterBody2D) -> void:
	# Mantém o player parado enquanto não há input
	player.velocity = Vector2.ZERO
 
 
func exit(_player: CharacterBody2D) -> void:
	pass
 
 
func get_transition(player: CharacterBody2D) -> StringName:
	# Prioridade: Dash > Move
	if player.is_dash_just_pressed() and player.can_dash():
		return STATE_DASH
	if player.get_move_input() != Vector2.ZERO:
		return STATE_MOVE
	return STATE_NONE
