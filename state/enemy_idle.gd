extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var chase_area: Area2D
@export var attack_area: Area2D
@export var visual: Node2D
@export var idle_timer: Timer
@export var move_speed := 10.0
@export var health_component: HealthComponent
@export var world: Node2D

var move_direction: Vector2
var wander_time: float
var player: CharacterBody2D
var is_wander = false
var is_start = false

func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	
func enter() -> void:
	world = get_tree().get_first_node_in_group("world")
	player = get_tree().get_first_node_in_group("player")
	randomize_wander()
	chase_area.body_entered.connect(on_chase_area_body_entered)
	attack_area.body_entered.connect(on_attack_area_body_entered)
	idle_timer.timeout.connect(on_idle_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	world.game_start.connect(on_game_start)
	idle_timer.wait_time = randi_range(1, 5)
	idle_timer.start()
	
func update(delta: float) -> void:
	if not is_wander:
		animation_player.play("idle")
	else:
		animation_player.play("walk")

func physics_update(delta: float) -> void:
	if not enemy:
		return
	if is_wander:
		enemy.velocity = move_direction * move_speed
	else:
		enemy.velocity = Vector2()
		randomize_wander()

func on_chase_area_body_entered(body: Node2D) -> void:
	if not is_start:
		return
	transitioned.emit(self, "EnemyFollow")

func on_attack_area_body_entered(body: Node2D) -> void:
	if not is_start:
		return
	transitioned.emit(self, "EnemyAttack")

func on_idle_timer_timeout() -> void:
	is_wander = not is_wander
	idle_timer.wait_time = randi_range(1, 5)
	idle_timer.start()

func on_health_changed() -> void:
	transitioned.emit(self, "EnemyDamaged")

func on_game_start() -> void:
	is_start = true

func exit() -> void:
	chase_area.body_entered.disconnect(on_chase_area_body_entered)
	attack_area.body_entered.disconnect(on_attack_area_body_entered)
	idle_timer.timeout.disconnect(on_idle_timer_timeout)
	health_component.health_changed.disconnect(on_health_changed)
	world.game_start.disconnect(on_game_start)
	
