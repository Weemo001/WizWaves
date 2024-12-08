extends Node3D

@export var enemy_scene: PackedScene # Put enemy scene here in inspector
@export var target: NodePath # Assign player node in inspector
@export var spawn_interval: float = 1.0 
@export var max_enemies: int = 10

var active_enemy_count = 0

func _ready():
	# On load, set timer wait time to spawn interval
	$SpawnTimer.wait_time = spawn_interval

func _input(event):
	# DEV TOOL - If dev key is pressed, start the spawner
	if event.is_action_pressed("dev1"):
		print("Spawner Active!") # DEBUG
		$SpawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	# When timer timeouts, if max enemy limit has been reached, stop the timer, clear the enemy counter
	if active_enemy_count == max_enemies:
		$SpawnTimer.stop()
		active_enemy_count = 0
		print("Spawner Deactivated.") # DEBUG
		return
	# Otherwise increment enemy counter and spawn an enemy
	else:
		active_enemy_count += 1
		spawn_enemy()

func spawn_enemy():
	# Instance a new enemy
	var enemy = enemy_scene.instantiate()
	
	# Get position of spawn area (Area3D) & The collision shape of the spawn area
	var collision_shape = $SpawnArea.get_node("CollisionShape3D").shape as BoxShape3D
	var extents = collision_shape.extents
	
	# Randomly generate position inside spawn shape based on extents of collision shape
	var random_offset = Vector3(
		randf_range(-extents.x, extents.x),
		0,
		randf_range(-extents.z, extents.z)
	)
	
	# Set enemy spawn position inside Area3D's collision shape + offset
	var spawn_position = $SpawnArea.global_position + random_offset
	enemy.transform.origin = spawn_position
	
	# Add enemy to scene, set target
	enemy.target = target
	get_parent().add_child(enemy)
