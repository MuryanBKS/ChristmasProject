extends Area2D
class_name snowball

var speed = 150
var target_position = Vector2.ZERO
var ball_position = Vector2.ZERO

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
