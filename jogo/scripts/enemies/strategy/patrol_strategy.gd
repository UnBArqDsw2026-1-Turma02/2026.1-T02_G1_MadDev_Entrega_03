## Strategy Pattern — patrulha: move o inimigo em ciclo por uma lista de pontos
##                     globais predefinidos, ignorando o alvo.
##
## Útil para inimigos de guarda ou sentinela que percorrem uma rota fixa.
## Combine com outra estratégia (ex: troque para DirectChaseStrategy quando o
## player entrar no campo de visão) para comportamento mais rico.
##
## Configuração:
##   - Preencha patrol_points com posições globais (Vector2) no inspetor ou via código.
##   - Ajuste patrol_threshold para controlar a distância de chegada a cada ponto.
##   - Se patrol_points estiver vazio, o inimigo fica parado e emite um aviso.
extends MoveStrategy
class_name PatrolStrategy
 
 
## Lista de posições globais (Vector2) que formam a rota de patrulha.
## Preenchida via inspetor ou programaticamente antes do inimigo entrar em cena.
@export var patrol_points: Array[Vector2] = []
 
## Distância em pixels para considerar que o inimigo chegou ao ponto atual.
@export var patrol_threshold: float = 12.0
 
## Índice do ponto de patrulha atual — avança automaticamente ao chegar.
var _current_idx: int = 0
 
 
func get_velocity(enemy: CharacterBody2D, _target: Node2D) -> Vector2:
	if patrol_points.is_empty():
		push_warning(
			"PatrolStrategy em '%s': patrol_points está vazio. " \
			% enemy.name +
			"Preencha ao menos um ponto para o inimigo se mover."
		)
		return Vector2.ZERO
 
	var destination: Vector2 = patrol_points[_current_idx]
	var to_dest: Vector2     = destination - enemy.global_position
 
	# Chegou ao ponto atual — avança para o próximo em ciclo
	if to_dest.length() <= patrol_threshold:
		_current_idx = (_current_idx + 1) % patrol_points.size()
		destination  = patrol_points[_current_idx]
		to_dest      = destination - enemy.global_position
 
	return to_dest.normalized() * enemy.move_speed
