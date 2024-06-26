extends CharacterBody2D

@onready var visual: Node2D = $Visual
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var world: Node2D
@export var max_speed = 75.0
@export var acceleration = 1000
@export var snowball_scene = preload("res://scenes/snowball/snowball.tscn")
@onready var progress_bar: ProgressBar = $Visual/ProgressBar

var can_throw = true
var can_move = true
var is_hurt = false
var is_start = false

func _ready() -> void:
	world.game_start.connect(on_game_start)
	can_move = true

func _physics_process(delta: float) -> void:
	var input_axis = get_direction()
	if not is_start:
		return
	if not can_move:
		return
	progress_bar.value = $CooldownTimer.time_left
	apply_speed(input_axis, max_speed)
	apply_friction(input_axis, delta)
	
	if Input.is_action_just_pressed("throw") and can_throw:
		var target_pos = get_global_mouse_position()
		if (target_pos - global_position).length() < 1:
			return
		can_throw = false
		if get_local_mouse_position().x > 0:
			visual.scale.x = 1
		else:
			visual.scale.x = -1
		can_move = false
		animation_player.play("throw_front")
		await animation_player.animation_finished
		throw_snow_ball(target_pos)
		$CooldownTimer.start()
		$StopMoveTimer.start()
	
	move_and_slide()
	update_animation()

func apply_speed(input_axis: Vector2, speed: float) -> void:
	if input_axis and not is_hurt:
		velocity = input_axis * speed

func apply_friction(input_axis: Vector2, delta: float) -> void:
	if not input_axis:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.y = move_toward(velocity.y, 0, acceleration * delta)

func get_direction() -> Vector2:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return direction

func throw_snow_ball(target_pos: Vector2) -> void:
	$IdleTimer.start()
	var snowball_scene_instance = snowball_scene.instantiate()
	var direction = (target_pos - global_position).normalized()
	snowball_scene_instance.target_pos = target_pos
	snowball_scene_instance.direction = direction
	snowball_scene_instance.start(global_position, 1)
	get_tree().get_first_node_in_group("snowballs").add_child(snowball_scene_instance)
	
	

func update_animation() -> void:
	var input_axis = get_direction()
	if input_axis.x > 0:
		visual.scale.x = 1
	elif input_axis.x < 0:
		visual.scale.x = -1
		
	if input_axis and not is_hurt:
		$IdleTimer.start()
		animation_player.play("walk_front")
	elif !input_axis:
		$IdleTimer.start()


func _on_health_component_health_changed() -> void:
	is_hurt = true
	animation_player.stop()
	velocity = Vector2()
	animation_player.play("damage")
	await animation_player.animation_finished
	is_hurt = false
	animation_player.play("idle_front")


func _on_idle_timer_timeout() -> void:
	if velocity.length() > 0:
		return
	animation_player.play("idle_front")


func on_game_start() -> void:
	is_start = true


func _on_cooldown_timer_timeout() -> void:
	can_throw = true


func _on_stop_move_timer_timeout() -> void:
	can_move = true
