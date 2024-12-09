extends CharacterBody3D

@onready var camera_origin: Node3D = $"Camera Origin"
@onready var visuals: Node3D = $Visuals
@onready var bullet = preload("res://Scenes/Player/projectile.tscn")

@export var SPEED = 5.0
@export var sensitivity = 0.5
@export var health = 10

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		# Fix visuals turning at odd angles
		visuals.rotate_y(deg_to_rad(event.relative.x * sensitivity))
		camera_origin.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		# Prevent camera from flipping
		camera_origin.rotation.x = clamp(camera_origin.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	
	# Quit game on button press
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(_delta: float) -> void:
	# Player movement 
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		visuals.look_at(position + direction) # Rotate player visuals towards movement direction
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func shoot():
	if bullet:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = $ProjectileSpawn.global_position
		bullet_instance.direction = -global_transform.basis.z.normalized()
		get_parent().add_child(bullet_instance)

func take_damage(amount: float):
	# Reduce health by amount, if health is 0, kill player
	print("Player took " + str(amount) + " damage!") # DEBUG
	health -= amount
	if health <= 0:
		_die()
		
func _die():
	print("Player has died!") # DEBUG
