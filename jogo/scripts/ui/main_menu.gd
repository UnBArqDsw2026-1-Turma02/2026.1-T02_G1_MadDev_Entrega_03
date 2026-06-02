extends Control

func _on_start_pressed() -> void:
	GameFacade.start_run()
	get_tree().change_scene_to_file("res://scenes/world/run.tscn")

func _on_quit_pressed() -> void:
	GameFacade.end_run(false)
	get_tree().quit()
