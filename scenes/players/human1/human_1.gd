extends CharacterBody2D

@onready var visual: Node2D = $Visual
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_speed = 75.0
@export var acceleration = 1000
@export var snowball_scene = preload("res://scenes/snowball/snowball.tscn")

var can_throw = true
var pressed_gather = false

func _physics_process(delta: float) -> void:
	var input_axis = get_direction()
	
	if not can_throw or pressed_gather:
		input_axis = Vector2.ZERO
	
	apply_speed(input_axis, max_speed)
	apply_friction(input_axis, delta)
	
	if Input.is_action_just_pressed("throw"):
		can_throw = false
		if get_local_mouse_position().x > 0:
			visual.scale.x = 1
		else:
			visual.scale.x = -1
		animation_player.play("throw_front")
		await animation_player.animation_finished
		can_throw = true
		throw_snow_ball(get_global_mouse_position())
	
	move_and_slide()
	update_animation()

func apply_speed(input_axis: Vector2, speed: float) -> void:
	if input_axis:
		velocity = input_axis * speed

func apply_friction(input_axis: Vector2, delta: float) -> void:
	if not input_axis:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.y = move_toward(velocity.y, 0, acceleration * delta)

func get_direction() -> Vector2:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return direction

func throw_snow_ball(target_pos: Vector2) -> void:
	var snowball_scene_instance = snowball_scene.instantiate()
	var direction = (target_pos - position).normalized()
	snowball_scene_instance.target_position = target_pos
	snowball_scene_instance.ball_position = position + direction * 10
	snowball_scene_instance.start(position + direction * 10, target_pos)
	get_tree().root.add_child(snowball_scene_instance)

func update_animation() -> void:
	var input_axis = get_direction()
	
	#if Input.is_action_pressed("gather"):
		#pressed_gather = true
		#animation_player.play("gather_front")
	#elif Input.is_action_just_released("gather"):
		#pressed_gather = false
	
	if pressed_gather:
		return
		
	if not can_throw:
		return
		
	if input_axis.x > 0:
		visual.scale.x = 1
	elif input_axis.x < 0:
		visual.scale.x = -1
		
	if not input_axis:
		animation_player.play("idle_front")
	if input_axis:
		animation_player.play("walk_front")
