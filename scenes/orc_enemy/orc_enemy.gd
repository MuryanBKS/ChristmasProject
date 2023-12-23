extends CharacterBody2D
class_name OrcEnemy

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.x > 0:
		$Visual.scale.x = 1
	elif velocity.x < 0:
		$Visual.scale.x = -1
	
	if velocity.length() > 0:
		$AnimationPlayer.play("walk")
