## State Pattern — estado Attack: player executando um ataque.
##
## Implementação inicial como placeholder estruturado.
## A lógica de animação, hitbox e dano será adicionada aqui conforme
## o sistema de combate for desenvolvido (issue futura).
##
## Transições possíveis:
##   → Idle : ao fim da animação de ataque (por enquanto, imediato)
extends PlayerState
class_name AttackState
 
 
# Duração do estado de ataque — será substituída pela duração real da animação
var _attack_duration: float = 0.3
var _elapsed: float = 0.0
 
 
func enter(_player: CharacterBody2D) -> void:
	_elapsed = 0.0
	# TODO: disparar animação de ataque e habilitar hitbox
 
 
func update(delta: float, _player: CharacterBody2D) -> void:
	_elapsed += delta
	# Player não se move durante o ataque
	_player.velocity = Vector2.ZERO
 
 
func exit(_player: CharacterBody2D) -> void:
	pass
	# TODO: desabilitar hitbox
 
 
func get_transition(_player: CharacterBody2D) -> StringName:
	if _elapsed >= _attack_duration:
		return STATE_IDLE
	return STATE_NONE
