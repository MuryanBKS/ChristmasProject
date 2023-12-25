extends State
class_name EnemyAttack

@export var enemy: CharacterBody2D
@export var snowball_scene = preload("res://scenes/snowball/snowball.tscn")
@export var cooldown_timer: Timer
@export var idle_timer: Timer
@export var raycast2D: RayCast2D
@export var chase_area: Area2D
@export var attack_area: Area2D
@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent
var player: CharacterBody2D

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	idle_timer.timeout.connect(on_idle_timer_timeout)
	attack_area.body_exited.connect(on_body_attack_area_exited)
	health_component.health_changed.connect(on_health_changed)
	enemy.velocity = lerp(enemy.velocity, Vector2(), 0.1)
	animation_player.stop()
	cooldown_timer.wait_time = randf_range(.3,.5)
	cooldown_timer.start()
	
	
func physics_update(delta: float) -> void:
	if !player:
		return
	raycast2D.target_position = player.global_position - enemy.global_position
	if raycast2D.is_colliding():
		if raycast2D.get_collider().get("name") != "Player":
			cooldown_timer.paused = true
			if idle_timer.is_stopped():
				idle_timer.wait_time = 1
				idle_timer.start()
		else:
			idle_timer.stop()
			cooldown_timer.paused = false
		
	if !cooldown_timer.is_stopped():
		return
		

func throw() -> void:
	if !player:
		return
	var direction = (player.global_position - enemy.global_position).normalized()
	var snowball_scene_instance = snowball_scene.instantiate()
	snowball_scene_instance.target_pos = player.global_position
	snowball_scene_instance.direction = direction
	snowball_scene_instance.start(enemy.global_position, 5)
	get_tree().root.add_child(snowball_scene_instance)

func on_cooldown_timer_timeout() -> void:
	animation_player.play("throw")
	await animation_player.animation_finished
	throw()
	cooldown_timer.wait_time = randf_range(1,5)
	cooldown_timer.start()
	
	
func on_idle_timer_timeout() -> void:
	transitioned.emit(self, "EnemyIdle")
	
func on_body_attack_area_exited(body: Node2D) -> void:
	transitioned.emit(self, "EnemyFollow")

func on_health_changed() -> void:
	transitioned.emit(self, "EnemyDamaged")
	
func exit() -> void:
	cooldown_timer.stop()
	cooldown_timer.timeout.disconnect(on_cooldown_timer_timeout)
	attack_area.body_exited.disconnect(on_body_attack_area_exited)
	idle_timer.timeout.disconnect(on_idle_timer_timeout)
	health_component.health_changed.disconnect(on_health_changed)
