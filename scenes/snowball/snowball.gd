extends Area2D
class_name Snowball

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target_pos: Vector2
var speed = 90
var direction: Vector2
var attack_damage = 1
var explode_was_played = false

func _ready() -> void:
	look_at(target_pos)
	animation_player.play("default")
	await get_tree().create_timer(.1).timeout
	monitoring = true

func start(start_pos: Vector2, distance: int) -> void:
	global_position = start_pos + direction * distance
	
	
func _physics_process(delta: float) -> void:
	move(delta) 

func move(delta: float) -> void:
	position += speed * direction * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	explode_was_played = true
	set_deferred("monitoring", false)
	speed = 10
	if explode_was_played:
		animation_player.play("explode")
		explode_was_played = true
		await animation_player.animation_finished
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	explode_was_played = true
	set_deferred("monitoring", false)
	speed = 10
	if area.has_method("damage"):
		area.damage()
	if explode_was_played:
		animation_player.play("explode")
		await animation_player.animation_finished
	queue_free()

func _on_fly_timer_timeout() -> void:
	speed = 10
	animation_player.play("explode")
	await animation_player.animation_finished
	queue_free()
