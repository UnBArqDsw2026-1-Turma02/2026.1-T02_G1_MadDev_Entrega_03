## Bridge Pattern — Abstração. Define O QUE o HUD exibe (HP, score, tempo) e
## delega O COMO para um UIRenderer intercambiável (CanvasRenderer / DebugRenderer).
## Trocar o renderer no Inspector muda a renderização sem alterar esta classe.
## Observer Pattern — recebe eventos do SignalBus para atualização automática.
## Iterator Pattern — update_consumables() percorre os slots do inventário.
extends Control
class_name HUDAbstraction

# ---------------------------------------------------------------------------
# Bridge — referência para a Implementação (atribuída pelo Inspector)
# ---------------------------------------------------------------------------
@export var renderer: UIRenderer

# ---------------------------------------------------------------------------
# Referências aos nós da cena (lado visual)
# ---------------------------------------------------------------------------
@onready var _hp_bar: ProgressBar = $VBoxContainer/HealthRow/HealthBar
@onready var _hp_label: Label = $VBoxContainer/HealthRow/HealthLabel
@onready var _score_label: Label = $VBoxContainer/ScoreLabel
@onready var _time_label: Label = $VBoxContainer/TimeLabel
@onready var _consumable_bar: HBoxContainer = $VBoxContainer/ConsumableRow

# ---------------------------------------------------------------------------
# Estado do cronômetro da run
# ---------------------------------------------------------------------------
var _elapsed_time: float = 0.0
var _run_active: bool = false
var _time_running: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if renderer != null:
		renderer.bind({
			"hp_bar": _hp_bar,
			"hp_label": _hp_label,
			"score_label": _score_label,
			"time_label": _time_label,
		})
	# Observer — conexões por código (consistente com pause_menu.gd)
	SignalBus.player_health_changed.connect(_on_player_health_changed)
	SignalBus.score_changed.connect(_on_score_changed)
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.run_ended.connect(_on_run_ended)
	SignalBus.game_paused.connect(_on_game_paused)


func _process(delta: float) -> void:
	if not _time_running:
		return
	_elapsed_time += delta
	if renderer != null:
		renderer.render_time(_elapsed_time)


# ---------------------------------------------------------------------------
# Bridge — métodos de alto nível que delegam ao renderer
# ---------------------------------------------------------------------------
func _render_hp(value: float, max_value: float) -> void:
	if renderer != null:
		renderer.render_hp(value, max_value)


# ---------------------------------------------------------------------------
# Observer — receptores de eventos do SignalBus
# ---------------------------------------------------------------------------
func _on_player_health_changed(new_health: int, max_health: int) -> void:
	_render_hp(float(new_health), float(max_health))


func _on_score_changed(new_score: int) -> void:
	if renderer != null:
		renderer.render_score(new_score)


func _on_run_started() -> void:
	_elapsed_time = 0.0
	_run_active = true
	_time_running = true


func _on_run_ended(_victory: bool) -> void:
	_run_active = false
	_time_running = false


func _on_game_paused(is_paused: bool) -> void:
	_time_running = _run_active and not is_paused


# ---------------------------------------------------------------------------
# Compatibilidade — conexão do inspetor vinda do Player (test_room.tscn)
# ---------------------------------------------------------------------------
## Mantido para a connection "health_changed" Player -> HUD em test_room.tscn.
func on_player_health_changed(new_health: int, max_health: int) -> void:
	_render_hp(float(new_health), float(max_health))


# ---------------------------------------------------------------------------
# Iterator — itera sobre os dados de consumíveis e atualiza os ícones
# ---------------------------------------------------------------------------
func update_consumables(consumable_list: Array) -> void:
	for child in _consumable_bar.get_children():
		child.queue_free()
	for item in consumable_list:
		var label := Label.new()
		label.text = str(item)
		_consumable_bar.add_child(label)
