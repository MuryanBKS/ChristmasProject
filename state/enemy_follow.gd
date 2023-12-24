extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var chase_area: Area2D
@export var attack_area: Area2D
@export var move_speed := 40.0
@export var animation_player: AnimationPlayer

var player: CharacterBody2D

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	chase_area.body_exited.connect(on_body_chase_area_exited)
	attack_area.body_entered.connect(on_body_attack_area_entered)
	animation_player.play("walk")
	
func physics_update(delta: float) -> void:
	if !player:
		return
	var direction = player.global_position - enemy.global_position
	enemy.velocity = direction.normalized() * move_speed
	animation_player.play("walk")
	
func on_body_chase_area_exited(body: Node2D) -> void:
	transitioned.emit(self, "EnemyIdle")

func on_body_attack_area_entered(body: Node2D) -> void:
	transitioned.emit(self, "EnemyAttack")

func exit() -> void:
	enemy.velocity = Vector2()
	chase_area.body_exited.disconnect(on_body_chase_area_exited)
	attack_area.body_entered.disconnect(on_body_attack_area_entered)
	
