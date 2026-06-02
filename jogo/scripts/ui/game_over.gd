## Tela de fim de jogo (Game Over / Vitória).
## Observer — escuta SignalBus.run_ended (Mediator) e exibe o resultado.
## O botão "Voltar ao Menu" é conectado via inspetor (sinal pressed).
extends Control

@onready var _title: Label = $Center/VBox/Title


func _ready() -> void:
	hide()
	SignalBus.run_ended.connect(_on_run_ended)


func _on_run_ended(victory: bool) -> void:
	_title.text = "VITÓRIA!" if victory else "VOCÊ MORREU"
	show()
	get_tree().paused = true


func _on_voltar_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
