## Mediator Pattern — ponto central de comunicação entre sistemas desacoplados.
## Nenhum nó deve conectar sinais diretamente em outro nó de domínio diferente;
## use SignalBus.algum_sinal.emit() / SignalBus.algum_sinal.connect() no lugar.
extends Node

# ---------------------------------------------------------------------------
# Jogador
# ---------------------------------------------------------------------------
signal player_health_changed(new_health: int, max_health: int)
signal player_died()
signal player_leveled_up(new_level: int)

# ---------------------------------------------------------------------------
# Inimigos
# ---------------------------------------------------------------------------
signal enemy_spawned(enemy: Node)
signal enemy_died(enemy: Node)
signal all_enemies_cleared()

# ---------------------------------------------------------------------------
# Sala / Mundo
# ---------------------------------------------------------------------------
signal room_entered(room_id: int)
signal room_cleared()
signal door_lock_changed(door_id: String, locked: bool)

# ---------------------------------------------------------------------------
# Itens / Inventário
# ---------------------------------------------------------------------------
signal item_picked_up(item_data: Dictionary)
signal consumable_used(consumable_type: String)

# ---------------------------------------------------------------------------
# Jogo / Meta
# ---------------------------------------------------------------------------
signal run_started()
signal run_ended(victory: bool)
signal game_paused(is_paused: bool)
signal score_changed(new_score: int)
signal achievement_unlocked(achievement: Achievement)
