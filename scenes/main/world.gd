extends Node2D

@export var background: Color

func _ready() -> void:
	RenderingServer.set_default_clear_color(background)

