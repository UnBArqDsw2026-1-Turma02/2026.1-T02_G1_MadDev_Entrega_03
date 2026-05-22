## Strategy Pattern — interface base para todas as estratégias de movimento de inimigos.
##
## Cada estratégia encapsula um algoritmo de pathfinding independente.
## O inimigo delega o cálculo de velocidade à estratégia ativa via
## move_strategy.get_velocity(self, _target), sem saber qual algoritmo
## está sendo executado.
##
## Para criar uma nova estratégia:
##   extends MoveStrategy
##   class_name MinhaEstrategia
##
##   func get_velocity(enemy: CharacterBody2D, target: Node2D) -> Vector2:
##       return ...
##
## A estratégia é trocada em tempo de execução apenas alterando a variável
## @export move_strategy no inspetor ou via código, sem alterar enemy_base.
extends Resource
class_name MoveStrategy
 
 
## Calcula e retorna o vetor de velocidade para este frame.
##
## Parâmetros:
##   enemy  — o inimigo que está se movendo (acesse move_speed, global_position, etc.)
##   target — o alvo atual (geralmente o player); pode ser null, trate o caso.
##
## Retorna Vector2.ZERO para manter o inimigo parado.
func get_velocity(enemy: CharacterBody2D, target: Node2D) -> Vector2:
	return Vector2.ZERO
