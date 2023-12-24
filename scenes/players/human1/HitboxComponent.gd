extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent

func damage() -> void:
	if health_component:
		health_component.damage()
