extends CharacterBody3D

@export var speed: float = 3.0
@export var target: NodePath # Assign player node in inspector
@export var damage: float = 1.0
@export var damage_tick: float = 1.0

var can_attack: bool = true
var is_in_range: bool = false

func _ready() -> void:
	# Set the wait time of the damage timer to the tick time variable
	$DamageTimer.wait_time = damage_tick

func _physics_process(_delta: float) -> void:
	# Move towards player and try to attack
	move_towards_player()
	try_attack()

func move_towards_player():
	# If target variable is assigned, set the direction to the face it and move towards it 
	if target:
		var direction = (get_node(target).global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func try_attack():
	# Try to attack the player if they are in range and attack is off cooldown and target is not dead, then start attack cooldown
	if is_in_range && can_attack && get_node(target).health > 0:
		get_node(target).take_damage(damage)
		can_attack = false
		$DamageTimer.start()

func _on_damage_timer_timeout():
	# Make the enemy able to attack when the attack cooldown timer ends
	can_attack = true

# Area3D collision detection functions: enter/exit
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		is_in_range = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		is_in_range = false
