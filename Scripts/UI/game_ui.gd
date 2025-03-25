extends Control

@onready var health_bar = $Healthbar
@onready var wave_counter = $MarginContainer/VBoxContainer/Wave
@onready var enemy_counter = $MarginContainer/VBoxContainer/Enemies
@onready var score_counter = $MarginContainer/VBoxContainer/Score

func update_health(new_health: int):
	health_bar.value = new_health

func update_wave(new_wave: int):
	wave_counter.text = "Wave: " + str(new_wave)

# Bad way of doing this to update stuff that isn't updating every tick, but I don't want to redo codebase for this project lol
func _process(_delta: float) -> void:
	enemy_counter.text = "Enemies: " + str(Global.active_enemies.size())
	score_counter.text = "Score: " + str(Global.score)
