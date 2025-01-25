extends CharacterBody2D

@export var hp : = 3
@export var porjectile_scene: PackedScene
const SPEED = 300
const JUMP_VELOCITY = -400.0
var movement_direction : Vector2
var can_move : bool
var can_shoot : bool
var player_global_position : Vector2
var player : Area2D

func _physics_process(delta: float) -> void:
	if can_move:
		move_to_player()
	else:
		velocity = Vector2(0,0)
	
	move_and_slide()


func move_to_player():
	movement_direction = (player_global_position - global_position).normalized()
	velocity = movement_direction * SPEED
	move_and_slide()

func _on_detection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player = area
		can_move = true
func _on_detection_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		can_move = false
