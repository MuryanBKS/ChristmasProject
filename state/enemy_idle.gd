extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var visual: Node2D
@export var move_speed := 10.0

var move_direction: Vector2
var wander_time: float

func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 2)
	
func enter() -> void:
	randomize_wander()
	
func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
	
	if move_direction.x > 0:
		visual.scale.x = 1
	elif move_direction.x < 0:
		visual.scale.x = -1
	
	if animation_player:
		animation_player.play("walk")

func physics_update(delta: float) -> void:
	if enemy:
		enemy.velocity = move_direction * move_speed
