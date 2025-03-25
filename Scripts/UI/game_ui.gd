extends Control

@onready var health_bar = $HealthBar

func update(new_health: int):
	health_bar.value = new_health
