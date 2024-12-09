extends RigidBody3D

var speed = 20
var direction = Vector3.ZERO

func _ready() -> void:
	gravity_scale = 0

func _physics_process(delta: float) -> void:
	# Set bullet movement, if it collides, check if it hit an enemy, if so clear enemy and remove from tracked array, then delete bullet, else just delete bullet
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		if collision.get_collider().is_in_group("enemy"):
			collision.get_collider().queue_free()
			Global.active_enemies.pop_back()
		queue_free()
