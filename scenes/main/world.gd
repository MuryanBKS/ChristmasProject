extends Node2D

signal game_start

@onready var start_button: Button = %StartButton
@onready var restart_button: Button = %RestartButton
@onready var next_level_button: Button = %NextLevelButton

@export var next_level: PackedScene

func _ready() -> void:
	LevelTransition.fade_from_black()
	start_button.show()
	restart_button.hide()
	next_level_button.hide()
	GameEvent.player_died.connect(on_player_died)
	GameEvent.win.connect(on_win)


func go_to_next_level(next_level_scene: PackedScene) -> void:
	if not next_level is PackedScene: return
	get_tree().change_scene_to_packed(next_level_scene)

func _on_button_button_down() -> void:
	game_start.emit()
	start_button.hide()


func _on_restart_button_button_down() -> void:
	get_tree().reload_current_scene()

func on_player_died() -> void:
	restart_button.show()

func on_win() -> void:
	restart_button.show()
	next_level_button.show()
	LevelTransition.fade_to_black()


func _on_next_level_button_button_down() -> void:
	go_to_next_level(next_level)
