extends CharacterBody3D

@onready var pivot: Node3D = $"Camera Origin"

@export var SPEED = 5.0
@export var sens = 0.5
@export var health = 10

func _ready():
	# Capture mouse so it doesn't go outside of the game window
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens)) # Rotate player side to side
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens)) # Rotate camera up and down
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45)) # Clamp camera so that it doesn't go into ground or over player's head
		
	# Quit the game when quit button is pressed
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func take_damage(amount: float):
	# Reduce health by amount, if health is 0, kill player
	print("Player took " + str(amount) + " damage!") # DEBUG
	health -= amount
	if health <= 0:
		_die()
		
func _die():
	print("Player has died!") # DEBUG
