extends CharacterBody2D

@export var hp : = 3
const SPEED = 300
const JUMP_VELOCITY = -400.0
var movement_direction : Vector2
var can_move : bool
var player_global_position : Vector2


func _physics_process(delta: float) -> void:
	print(can_move)
	look_at(player_global_position)
	if can_move:
		velocity += transform.x * SPEED * delta
	else:
		velocity = Vector2(0,0)
		
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


func _on_hitbox_area_entered(area: Area2D) -> void:
	hp -= 1
	var original_color =  get_modulate()
	set_modulate("red")
	await get_tree().create_timer(0.2).timeout
	set_modulate(original_color)
	if hp <= 0:
		queue_free()
