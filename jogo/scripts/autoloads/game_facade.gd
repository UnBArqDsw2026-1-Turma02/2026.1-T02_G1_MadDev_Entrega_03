## Facade Pattern
## Interface simplificada para os subsistemas do jogo (Audio, Game, Signals)
## Registre como Autoload com nome "GameFacade" no project.godot
extends Node

# ---------------------------------------------------------------------------
# Subsistemas (acessados via autoload)
# ---------------------------------------------------------------------------
# AudioManager, GameManager e SignalBus já estão registrados como autoloads

# ---------------------------------------------------------------------------
# Métodos de Áudio (AudioManager)
# ---------------------------------------------------------------------------

## Toca um efeito sonoro
## @param sfx_name: Nome do arquivo de som (ex: "shoot", "explosion")
func play_sound(sfx_name: String) -> void:
	# Exemplo: carrega e toca o som baseado no nome
	var sfx_stream = load("res://art/sounds/" + sfx_name + ".wav")
	if sfx_stream:
		AudioManager.play_sfx(sfx_stream)
	else:
		push_warning("GameFacade: som não encontrado - ", sfx_name)


## Toca música de fundo
## @param music_name: Nome do arquivo de música
func play_music(music_name: String) -> void:
	var music_stream = load("res://art/music/" + music_name + ".wav")
	if music_stream:
		AudioManager.play_music(music_stream)
	else:
		push_warning("GameFacade: música não encontrada - ", music_name)


## Para a música atual
func stop_music() -> void:
	AudioManager.stop_music()


# ---------------------------------------------------------------------------
# Métodos do Jogo (GameManager)
# ---------------------------------------------------------------------------

## Adiciona pontos ao placar
## @param amount: Quantidade de pontos a adicionar
func award_points(amount: int) -> void:
	GameManager.add_score(amount)


## Reseta o estado da run (permadeath)
func reset_game_state() -> void:
	GameManager.reset_run()


## Finaliza a run atual
## @param victory: true se venceu, false se perdeu
func end_run(victory: bool) -> void:
	GameManager.end_run(victory)


## Pausa ou despausa o jogo
func toggle_pause() -> void:
	GameManager.toggle_pause()


# ---------------------------------------------------------------------------
# Métodos de Sinais (SignalBus)
# ---------------------------------------------------------------------------

## Emite sinal que o jogador morreu
func emit_player_died() -> void:
	SignalBus.player_died.emit()


## Emite sinal que um inimigo morreu
## @param enemy: Referência ao inimigo que morreu
func emit_enemy_died(enemy: Node) -> void:
	SignalBus.enemy_died.emit(enemy)


## Emite sinal que a sala foi limpa (todos inimigos mortos)
func emit_room_cleared() -> void:
	SignalBus.room_cleared.emit()


## Emite sinal que a pontuação mudou
## @param new_score: Nova pontuação
func emit_score_changed(new_score: int) -> void:
	SignalBus.score_changed.emit(new_score)


## Emite sinal que o jogo foi pausado
## @param is_paused: true se pausado, false se despausado
func emit_game_paused(is_paused: bool) -> void:
	SignalBus.game_paused.emit(is_paused)


# ---------------------------------------------------------------------------
# Métodos Combinados (exemplos de uso mais complexo)
# ---------------------------------------------------------------------------

## Mata o jogador (som + sinal)
func kill_player() -> void:
	play_sound("death")
	emit_player_died()
	end_run(false)


## Vitória do jogador (música + sinal)
func victory() -> void:
	play_music("victory")
	end_run(true)


## Adiciona pontos com efeito sonoro
func award_points_with_sound(amount: int) -> void:
	award_points(amount)
	play_sound("point")
	emit_score_changed(GameManager.run_score)
