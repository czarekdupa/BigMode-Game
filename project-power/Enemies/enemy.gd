extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = -400.0
var movement_direction : Vector2
var can_move : bool
var player_global_position : Vector2


func _physics_process(delta: float) -> void:
	look_at(player_global_position)
	velocity += transform.x * SPEED * delta
	
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		movement_direction = (body.global_position - global_position).normalized()
		player_global_position = body.global_position
		can_move = true
	else:
		pass

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_move = false
	else:
		pass
