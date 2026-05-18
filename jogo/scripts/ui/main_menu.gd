extends Control

func _on_start_pressed() -> void:
	GameFacade.reset_game_state()  # ← USANDO A FACADE
	GameManager.start_run()
	get_tree().change_scene_to_file("res://scenes/world/test_room.tscn")

func _on_quit_pressed() -> void:
	GameFacade.end_run(false)  # ← USANDO A FACADE
	get_tree().quit()
