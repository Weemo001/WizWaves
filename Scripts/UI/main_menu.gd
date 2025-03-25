extends Control

func _ready():
	$Main.show()
	$HowToPlay.hide()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")

func _on_how_to_play_pressed() -> void:
	$Main.hide()
	$HowToPlay.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	$HowToPlay.hide()
	$Main.show()
