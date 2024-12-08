extends Node

@export var time_between_waves: float = 1.0 # sec
@export var spawn_interval: float = 0.5 # sec
@export var max_enemies: int = 20
@export var spawners: Array[Node3D] = []

var wave_counter: int = 0
var enemies_spawned_per_wave = 0

func _input(event): # DEBUG
	if event.is_action_pressed("dev1"):
		for e in Global.active_enemies:
			e.queue_free()
		Global.active_enemies.clear()
		
		if Global.active_enemies.size() == 0:
			print("Cleared enemies.")

func _ready():
	$WaveCDTimer.wait_time = time_between_waves
	$SpawnTimer.wait_time = spawn_interval

func _on_wave_cd_timer_timeout() -> void:
	# When wave timer times out, increment wave counter, reset current enemy counter, and start the spawn timer
	wave_counter += 1
	enemies_spawned_per_wave = 0
	print("Wave: " + str(wave_counter) + " has started.")
	
	$SpawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	# As long as the amount of enemies this wave hasn't maxed out, keep spawning enemies on every spawner.
	if enemies_spawned_per_wave < max_enemies:
		for s in spawners:
			s.spawn_enemy()
			enemies_spawned_per_wave += 1
		$SpawnTimer.start()
