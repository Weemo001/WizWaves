extends Control

signal game_reset

func _on_restart_pressed() -> void:
	get_tree().paused = false
	game_reset.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
