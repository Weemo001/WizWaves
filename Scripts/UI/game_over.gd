extends Control

@onready var score = $VBoxContainer/Score

signal game_reset

func _on_restart_pressed() -> void:
	get_tree().paused = false
	game_reset.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()

func update_score() -> void:
	score.text = "Score: " + str(Global.score)
