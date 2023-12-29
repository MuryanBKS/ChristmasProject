extends Node

signal player_died
signal win


var enemies_count = 0

func _ready() -> void:
	enemies_count = get_tree().get_nodes_in_group("enemies").size()

func restart() -> void:
	enemies_count = get_tree().get_nodes_in_group("enemies").size()
	print(enemies_count)
	
