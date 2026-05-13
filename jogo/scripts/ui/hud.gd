## Composite Pattern — HUD composto por sub-painéis independentes (vida, consumíveis).
## Observer Pattern — métodos públicos chamados via conexões do inspetor (SignalBus).
## Iterator Pattern — update_consumables() itera sobre os slots do inventário.
## Conexões de sinais devem ser feitas via inspetor, não via código.
extends Control

# ---------------------------------------------------------------------------
# Referências aos nós filhos (atribuídas via inspetor ou @onready)
# ---------------------------------------------------------------------------
@onready var health_bar: HBoxContainer = $VBoxContainer/HealthRow
@onready var consumable_bar: HBoxContainer = $VBoxContainer/ConsumableRow
@onready var health_label: Label = $VBoxContainer/HealthRow/HealthLabel


# ---------------------------------------------------------------------------
# Observer — receptores de eventos (conectar via inspetor no SignalBus)
# ---------------------------------------------------------------------------
func on_player_health_changed(new_health: int, max_health: int) -> void:
	if health_label == null:
		return
	health_label.text = "HP: %d / %d" % [new_health, max_health]


## Itera sobre os dados de consumíveis e atualiza os ícones (Iterator).
func update_consumables(consumable_list: Array) -> void:
	for child in consumable_bar.get_children():
		child.queue_free()
	for item in consumable_list:
		var label := Label.new()
		label.text = str(item)
		consumable_bar.add_child(label)
