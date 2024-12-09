extends RigidBody3D

var speed = 20
var direction = Vector3.ZERO

func _ready() -> void:
	gravity_scale = 0

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		queue_free()
