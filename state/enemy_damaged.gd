extends State
class_name EnemyDamaged

@export var enemy: CharacterBody2D
@export var animation_player: AnimationPlayer


func enter() -> void:
	enemy.velocity = Vector2()
	animation_player.stop()

func update(delta: float) -> void:
	animation_player.play("damage")
	await animation_player.animation_finished
	transitioned.emit(self, "EnemyAttack")
