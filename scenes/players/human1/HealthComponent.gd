extends Node2D
class_name HealthComponent

signal health_changed

@export var max_health := 10
var health: int

func _ready() -> void:
	health = max_health
	
func damage() -> void:
	health -= 1
	health_changed.emit()
	if health <= 0:
		get_parent().queue_free()
