extends CharacterBody3D

@onready var camera_origin: Node3D = $"Camera Origin"
@onready var visuals: Node3D = $Visuals
@onready var animation_player: AnimationPlayer = $Visuals/Player/AnimationPlayer

@export var health = 10
@export var SPEED = 5.0
@export var sensitivity = 0.5
@export var shoot_interval = 0.3
@export var bullet: PackedScene

signal health_changed(new_health)

func _ready():
	$ShootTimer.wait_time = shoot_interval

func _input(event):
	# Camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		# Fix visuals turning at odd angles
		visuals.rotate_y(deg_to_rad(event.relative.x * sensitivity))
		camera_origin.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		# Prevent camera from flipping
		camera_origin.rotation.x = clamp(camera_origin.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	
	# Extra check on shooting to prevent an extra projectile from being shot when the player releases the shoot button
	if event.is_action_released("shoot"):
		if not $ShootTimer.is_stopped():
			$ShootTimer.stop()

func _process(_delta: float) -> void:
	# When holding or pressing shoot button, shoot bullet at rate defined by shoot_interval
	if Input.is_action_pressed("shoot") && $ShootTimer.is_stopped():
		$ShootTimer.start()

func _physics_process(_delta: float) -> void:
	# Player movement 
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if animation_player.current_animation != "Player_Anim": # Animate player
			animation_player.play("Player_Anim")
		
		visuals.look_at(position + direction)  # Rotate player visuals towards movement direction
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		animation_player.stop() # Animate player
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func shoot():
	# Create an instance of the bullet, add it, set its position and direction, disable particle emission temporarily
	var bullet_instance = bullet.instantiate()
	bullet_instance.get_node("Visuals/CPUParticles3D").emitting = false
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = $ProjectileSpawn.global_position
	bullet_instance.direction = -global_transform.basis.z.normalized()
	
	# Set the orientation of the bullet, and turn on the particle emission. This prevents the particles from showing up briefly at 0,0
	bullet_instance.look_at(bullet_instance.global_position + bullet_instance.direction, Vector3.UP)
	bullet_instance.get_node("Visuals/CPUParticles3D").emitting = true

func take_damage(amount: float):
	# Reduce health by amount, if health is 0, kill player
	print("Player took " + str(amount) + " damage!") # DEBUG
	health -= amount
	health_changed.emit(health)
	if health <= 0:
		_die()
		
func _die():
	print("Player has died!") # DEBUG

func _on_shoot_timer_timeout() -> void:
	shoot()
