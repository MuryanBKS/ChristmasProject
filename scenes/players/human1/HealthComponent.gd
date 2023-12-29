extends Node2D
class_name HealthComponent

signal health_changed
signal died

@export var max_health := 10
var health: int
var player: CharacterBody2D

func _ready() -> void:
	health = max_health
	player= get_tree().get_first_node_in_group("player")
	
func damage() -> void:
	health -= 1
	health_changed.emit()
	if health <= 0:
		if get_parent() == player:
			GameEvent.player_died.emit()
		elif get_tree().get_nodes_in_group("enemies").has(get_parent()):
			GameEvent.enemies_count -= 1
			print(GameEvent.enemies_count)
			if GameEvent.enemies_count == 0:
				GameEvent.win.emit()
		died.emit()
