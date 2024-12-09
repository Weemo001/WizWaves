extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Visuals/Slime/AnimationPlayer

@export var speed: float = 3.0
@export var damage: float = 1.0
@export var damage_tick: float = 1.0

var can_attack: bool = true
var is_in_range: bool = false
var target: NodePath

func _ready() -> void:
	# Set the wait time of the damage timer to the tick time variable
	$DamageTimer.wait_time = damage_tick

func _physics_process(delta: float) -> void:
	# Move towards player and try to attack
	animation_player.play("Slime_ArmatureAction")
	
	# Update direction to be facing towards target
	var direction = (get_node(target).global_position - global_position).normalized()
	
	# Move and collide with player, if collided set in range
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		if collision.get_collider().is_in_group("player"):
			is_in_range = true
	
	_try_attack()

func _try_attack():
	# Try to attack the player if they are in range and attack is off cooldown and target is not dead, then start attack cooldown
	if is_in_range && can_attack && get_node(target).health > 0:
		get_node(target).take_damage(damage)
		can_attack = false
		$DamageTimer.start()

func _on_damage_timer_timeout():
	# Make the enemy able to attack when the attack cooldown timer ends
	can_attack = true
