## Singleton Pattern — instância global única que guarda o estado da run.
## Facade Pattern — reset_run() esconde a complexidade de reiniciar todos os sistemas.
## Conexões de sinais devem ser feitas via inspetor, não via código.
extends Node

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER, VICTORY }

func _ready() -> void:
	_initialize_difficulties()

func _initialize_difficulties() -> void:
	# Criando e configurando os níveis de balanceamento
	var easy: DifficultyConfig = DifficultyConfig.new()
	easy.setup(0.75, 0.85, 1.5)
	
	var normal: DifficultyConfig = DifficultyConfig.new()
	normal.setup(1.0, 1.0, 1.0)
	
	var hard: DifficultyConfig = DifficultyConfig.new()
	hard.setup(1.5, 1.2, 0.7)
	
	# Registrando as instâncias no Multiton
	DifficultyRegistry.register_difficulty(&"easy", easy)
	DifficultyRegistry.register_difficulty(&"normal", normal)
	DifficultyRegistry.register_difficulty(&"hard", hard)
	
	print("[GameManager] Dificuldades inicializadas com tipagem estática e registradas.")

# ---------------------------------------------------------------------------
# Estado da run corrente
# ---------------------------------------------------------------------------
var current_state: GameState = GameState.MENU
var current_room_index: int = 0
var run_score: int = 0

var player_level: int = 1
var player_xp: int = 0


# ---------------------------------------------------------------------------
# Facade — ponto único para iniciar/encerrar uma run
# ---------------------------------------------------------------------------
func start_run() -> void:
	reset_run()
	current_state = GameState.PLAYING
	SignalBus.run_started.emit()


## Reseta TODO o estado volátil da run (Permadeath).
## Outros sistemas devem ouvir SignalBus.run_ended via inspetor e limpar seu estado.
func reset_run() -> void:
	current_room_index = 0
	run_score = 0
	player_level = 1
	player_xp = 0


func end_run(victory: bool) -> void:
	current_state = GameState.VICTORY if victory else GameState.GAME_OVER
	SignalBus.run_ended.emit(victory)


func toggle_pause() -> void:
	var is_paused: bool = current_state != GameState.PAUSED
	current_state = GameState.PAUSED if is_paused else GameState.PLAYING
	get_tree().paused = is_paused
	SignalBus.game_paused.emit(is_paused)


func add_score(amount: int) -> void:
	run_score += amount
	SignalBus.score_changed.emit(run_score)
