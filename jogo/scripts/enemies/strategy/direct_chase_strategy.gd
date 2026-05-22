## Strategy Pattern — perseguição direta: move o inimigo em linha reta ao alvo,
##                     ignorando obstáculos.
##
## Comportamento mais simples e de menor custo computacional.
## Ideal para inimigos de curto alcance (melee) ou em salas abertas sem paredes.
## Troque para NavigationStrategy quando o inimigo precisar desviar de obstáculos.
extends MoveStrategy
class_name DirectChaseStrategy
 
 
func get_velocity(enemy: CharacterBody2D, target: Node2D) -> Vector2:
	if not is_instance_valid(target):
		return Vector2.ZERO
 
	var direction: Vector2 = (target.global_position - enemy.global_position).normalized()
	return direction * enemy.move_speed
