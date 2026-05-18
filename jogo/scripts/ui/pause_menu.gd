extends Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameMediator.register(GameMediator.EVENT_GAME_PAUSED, _on_mediator_game_paused)


func _exit_tree() -> void:
	GameMediator.unregister(GameMediator.EVENT_GAME_PAUSED, _on_mediator_game_paused)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.toggle_pause()
		get_viewport().set_input_as_handled()


func _on_game_paused(is_paused: bool) -> void:
	visible = is_paused


func _on_mediator_game_paused(_sender: Object, _event: StringName, data: Dictionary) -> void:
	_on_game_paused(data.get("is_paused", false))


func _on_resume_pressed() -> void:
	GameManager.toggle_pause()


func _on_quit_pressed() -> void:
	GameManager.end_run(false)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
