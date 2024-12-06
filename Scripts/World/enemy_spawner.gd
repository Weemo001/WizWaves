extends Node3D

@export var enemy_scene: PackedScene # Put enemy scene here in inspector
@export var target: NodePath # Assign player node in inspector
@export var spawn_interval: float = 1.0 
@export var max_enemies: int = 10

var active_enemies: Array = []

func _ready():
	$SpawnTimer.wait_time = spawn_interval
	$SpawnTimer.start()
	
func spawn_enemy():
	# Check if max enemy limit has been reached
	if active_enemies.size() >= max_enemies:
		return
	
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
	
	# Add enemy to scene, set target, and track it in list
	enemy.target = target
	get_parent().add_child(enemy)
	active_enemies.append(enemy)
	
	# Remove enemy from list when deleted
	enemy.connect("tree_exited", on_enemy_removed)

func on_enemy_removed(enemy):
	active_enemies.erase(enemy)
	
func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
