extends Node2D
class_name DeathComponent

@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer

func _ready() -> void:
	hide()
	health_component.died.connect(on_died)


func on_died() -> void:
	show()
	animation_player.play("died")
	await animation_player.animation_finished
	get_parent().queue_free()
