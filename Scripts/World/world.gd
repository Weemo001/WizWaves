extends Node

@export var time_between_waves: float = 1.0 # sec
@export var spawn_interval: float = 0.5 # sec
@export var max_enemies: int = 20
@export var spawners: Array[Node3D] = []
@export var difficulty_mod: float = 1.2

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
	$Timers/WaveCDTimer.wait_time = time_between_waves
	$Timers/SpawnTimer.wait_time = spawn_interval

func _on_wave_cd_timer_timeout() -> void:
	# Timer is always running, but only executes the spawning sequence code when the spawntimer is stopped, and the array of tracked enemies is empty
	if $Timers/SpawnTimer.is_stopped() && Global.active_enemies.size() == 0:
		wave_counter += 1
		
		# Simple ramping difficulty modifier
		max_enemies = 20 * pow(difficulty_mod, wave_counter - 1)
		
		enemies_spawned_per_wave = 0
		print("Wave: " + str(wave_counter) + " Enemies: " + str(max_enemies))
		
		$Timers/SpawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	# As long as the amount of enemies this wave hasn't maxed out, keep spawning enemies on every spawner.
	if enemies_spawned_per_wave < max_enemies:
		for s in spawners:
			s.spawn_enemy()
			enemies_spawned_per_wave += 1
		$Timers/SpawnTimer.start()
