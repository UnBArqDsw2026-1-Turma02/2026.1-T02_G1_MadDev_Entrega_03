## Strategy Pattern — pathfinding via NavigationAgent2D: move o inimigo desviando
##                     de obstáculos usando a malha de navegação da sala.
##
## Requer que o nó inimigo possua um filho do tipo NavigationAgent2D.
## Se o NavigationAgent2D não for encontrado, cai de volta para perseguição direta
## com um aviso no console, evitando crash silencioso.
##
## Configuração no inimigo:
##   1. Adicione um filho NavigationAgent2D ao nó do inimigo.
##   2. Configure max_speed, path_desired_distance, etc. no próprio NavigationAgent2D.
##   3. Atribua esta estratégia no @export move_strategy do inimigo.
extends MoveStrategy
class_name NavigationStrategy
 
 
## Nome do nó filho esperado — altere se o seu projeto usar outro nome.
const NAV_AGENT_NAME := "NavigationAgent2D"
 
 
func get_velocity(enemy: CharacterBody2D, target: Node2D) -> Vector2:
	if not is_instance_valid(target):
		return Vector2.ZERO
 
	var nav_agent := enemy.get_node_or_null(NAV_AGENT_NAME) as NavigationAgent2D
 
	if not is_instance_valid(nav_agent):
		push_warning(
			"NavigationStrategy: '%s' não encontrou um filho '%s'. " \
			% [enemy.name, NAV_AGENT_NAME] +
			"Caindo para perseguição direta. Adicione um NavigationAgent2D ao inimigo."
		)
		# Fallback: linha reta quando não há agente de navegação
		return (target.global_position - enemy.global_position).normalized() * enemy.move_speed
 
	# Atualiza o destino a cada frame para seguir o alvo em movimento
	nav_agent.target_position = target.global_position
 
	if nav_agent.is_navigation_finished():
		return Vector2.ZERO
 
	var next_position: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2    = (next_position - enemy.global_position).normalized()
	return direction * enemy.move_speed
