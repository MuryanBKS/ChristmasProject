extends AudioStreamPlayer2D
class_name HitSoundComponent

@export var health_component: HealthComponent

func _ready() -> void:
	health_component.health_changed.connect(on_health_changed)


func on_health_changed() -> void:
	play( )
