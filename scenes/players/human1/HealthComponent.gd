extends Node2D
class_name HealthComponent

@export var max_health := 10
var health: int

func _ready() -> void:
	health = max_health
	
func damage() -> void:
	health -= 1
	print(health)
	if health <= 0:
		get_parent().queue_free()
