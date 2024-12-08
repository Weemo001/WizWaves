extends Node3D

@export var enemy_scene: PackedScene # Put enemy scene here in inspector
@export var target: NodePath # Assign player node in inspector

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
	
	# Set enemy target, add to scene, track in global array
	enemy.target = target
	get_parent().add_child(enemy)
	Global.active_enemies.append(enemy)
