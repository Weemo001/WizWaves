extends CharacterBody3D

@export var speed: float = 3.0
@export var target: NodePath # Assign player node in inspector
@export var damage: float = 1.0
@export var damage_tick: float = 1.0

var can_attack: bool = true
var is_in_range: bool = false

func _ready() -> void:
	$DamageTimer.wait_time = damage_tick

func _physics_process(_delta: float) -> void:
	# Check if target is assigned
	if target:
		# Move towards target
		var direction = (get_node(target).global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	
	# Check if in range, can attack, and player isn't dead, then call the damage function on the player to deal damage
	if is_in_range && can_attack && get_node(target).health > 0:
		get_node(target).take_damage(damage)
		attack_cooldown()

# Cooldown for the attack so that the enemy isn't constantly attacking while colliding
func attack_cooldown():
	can_attack = false
	$DamageTimer.start()

func _on_damage_timer_timeout():
	can_attack = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		is_in_range = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		is_in_range = false
