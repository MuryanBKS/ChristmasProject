extends Area2D
class_name Snowball

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed = 90
var target_position = Vector2.ZERO
var ball_position = Vector2.ZERO
var attack_damage = 1

func _ready() -> void:
	animation_player.play("default")
	await get_tree().create_timer(.1).timeout
	monitoring = true

func start(start_position: Vector2, target_pos: Vector2) -> void:
	position = start_position
	look_at(target_pos)

func _physics_process(delta: float) -> void:
	move(delta) 

func get_direction(target_pos: Vector2, ball_pos: Vector2) -> Vector2:
	var direction = target_position - ball_position
	return direction.normalized()

func move(delta: float) -> void:
	position += speed * get_direction(target_position, ball_position) * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	animation_player.play("explode")
	speed = 75
	await animation_player.animation_finished
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("damage"):
		area.damage()


func _on_fly_timer_timeout() -> void:
	animation_player.play("explode")
	speed = 75
	await animation_player.animation_finished
	queue_free()
