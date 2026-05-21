## Singleton Pattern — instância global única que guarda o estado da run.
## Facade Pattern — reset_run() esconde a complexidade de reiniciar todos os sistemas.
## Conexões de sinais devem ser feitas via inspetor, não via código.
extends Node

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER, VICTORY }

# ---------------------------------------------------------------------------
# Estado da run corrente
# ---------------------------------------------------------------------------
var current_state: GameState = GameState.MENU
var current_room_index: int = 0
var run_score: int = 0

var player_level: int = 1
var player_xp: int = 0

# ---------------------------------------------------------------------------
# Geração de salas usando Builder (Issue 2)
# ---------------------------------------------------------------------------
var current_room: Node2D = null


# ---------------------------------------------------------------------------
# Facade — ponto único para iniciar/encerrar uma run
# ---------------------------------------------------------------------------
func start_run() -> void:
	reset_run()
	current_state = GameState.PLAYING
	GameMediator.notify(self, GameMediator.EVENT_RUN_STARTED)


## Reseta TODO o estado volátil da run (Permadeath).
## Outros sistemas devem ouvir SignalBus.run_ended via inspetor e limpar seu estado.
func reset_run() -> void:
	current_room_index = 0
	run_score = 0
	player_level = 1
	player_xp = 0


func end_run(victory: bool) -> void:
	current_state = GameState.VICTORY if victory else GameState.GAME_OVER
	GameMediator.notify(self, GameMediator.EVENT_RUN_ENDED, {"victory": victory})


func toggle_pause() -> void:
	var is_paused: bool = current_state != GameState.PAUSED
	current_state = GameState.PAUSED if is_paused else GameState.PLAYING
	get_tree().paused = is_paused
	GameMediator.notify(self, GameMediator.EVENT_GAME_PAUSED, {"is_paused": is_paused})


func add_score(amount: int) -> void:
	run_score += amount
	GameMediator.notify(self, GameMediator.EVENT_SCORE_CHANGED, {"new_score": run_score})
