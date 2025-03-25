extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Visuals/Slime/AnimationPlayer
@onready var damage_timer: Timer = $DamageTimer

@export var speed: float = 3.0
@export var damage: float = 1.0

var target: NodePath

func _physics_process(delta: float) -> void:
	# Move towards player
	animation_player.play("Slime_ArmatureAction")
	
	# Update direction to be facing towards target
	var direction = (get_node(target).global_position - global_position).normalized()
	
	# Move and collide with player, if collided fire timer
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		if collision.get_collider().is_in_group("player"):
			if damage_timer.is_stopped():
				damage_timer.start()

func _on_damage_timer_timeout() -> void:
	get_node(target).take_damage(damage)
