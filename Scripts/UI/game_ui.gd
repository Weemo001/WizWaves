extends Control

@onready var health_bar = $HealthbarRoot/Healthbar
@onready var wave_counter = $WaveCounterRoot/WaveCounter
@onready var enemy_counter = $EnemyCounterRoot/EnemyCounter
@onready var score_counter = $ScoreRoot/ScoreCounter

func update_health(new_health: int):
	health_bar.value = new_health

func update_wave(new_wave: int):
	wave_counter.text = str(new_wave)

# Bad way of doing this, but I would have had to redo my codebase for enemy spawning and despawning which I don't want to do for this project lol
func _process(_delta: float) -> void:
	enemy_counter.text = str(Global.active_enemies.size())
	score_counter.text = str(Global.score)
