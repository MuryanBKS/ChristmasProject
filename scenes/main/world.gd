extends Node2D

signal game_start

@onready var start_button: Button = %StartButton
@onready var restart_button: Button = %RestartButton



func _ready() -> void:
	start_button.show()
	restart_button.hide()
	GameEvent.player_died.connect(on_player_died)

func _on_button_button_down() -> void:
	game_start.emit()
	start_button.hide()


func _on_restart_button_button_down() -> void:
	get_tree().reload_current_scene()

func on_player_died() -> void:
	restart_button.show()
