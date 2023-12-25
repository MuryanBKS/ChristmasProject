extends Node2D

signal game_start

@onready var button: Button = %Button


func _ready() -> void:
	pass


func _on_button_button_down() -> void:
	game_start.emit()
	button.hide()
