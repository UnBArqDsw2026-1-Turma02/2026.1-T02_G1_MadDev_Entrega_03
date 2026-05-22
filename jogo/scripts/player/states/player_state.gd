## State Pattern — classe base para todos os estados da FSM do player.
##
## Cada estado é um Resource leve e independente. Recebe o player como parâmetro
## em todos os métodos, evitando referência direta e mantendo os estados
## intercambiáveis e testáveis de forma isolada.
##
## Para criar um novo estado:
##   extends PlayerState
##   class_name MeuEstado
##
##   func enter(player: CharacterBody2D) -> void: ...
##   func update(delta: float, player: CharacterBody2D) -> void: ...
##   func exit(player: CharacterBody2D) -> void: ...
##   func get_transition(player: CharacterBody2D) -> StringName: ...
extends Resource
class_name PlayerState
 
 
# ---------------------------------------------------------------------------
# Nomes dos estados — use estas constantes em get_transition() para evitar
# strings soltas pelo código.
# ---------------------------------------------------------------------------
const STATE_IDLE   := &"idle"
const STATE_MOVE   := &"move"
const STATE_DASH   := &"dash"
const STATE_ATTACK := &"attack"
const STATE_NONE   := &""
 
 
# ---------------------------------------------------------------------------
# Interface virtual — sobrescreva em cada estado concreto
# ---------------------------------------------------------------------------
 
## Chamado uma vez ao entrar no estado.
## Use para inicializar variáveis internas e configurar o player.
func enter(player: CharacterBody2D) -> void:
	pass
 
 
## Chamado a cada frame de física enquanto o estado estiver ativo.
## Aplique velocidade e demais efeitos contínuos aqui.
func update(delta: float, player: CharacterBody2D) -> void:
	pass
 
 
## Chamado uma vez ao sair do estado.
## Use para limpar efeitos, resetar flags ou disparar cooldowns.
func exit(player: CharacterBody2D) -> void:
	pass
 
 
## Retorna o nome do próximo estado, ou STATE_NONE para permanecer no atual.
## Consultado pelo player após cada update().
func get_transition(player: CharacterBody2D) -> StringName:
	return STATE_NONE
