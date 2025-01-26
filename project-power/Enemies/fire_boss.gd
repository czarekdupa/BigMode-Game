extends CharacterBody2D

@export_category("Stats")
@export var hp : = 3
@export var speed = 100
@export var projectile_scene: PackedScene

@export_category("Timers")
@export var fireball_timer_time := 3

@onready pass

var movement_direction : Vector2
var can_move : bool
var can_shoot : bool
var player : CharacterBody2D
	
func _physics_process(delta: float) -> void:
	if player:
		if can_move:
			move_to_player()
		if can_shoot:
			spawn_projectile()
		else:
			velocity = Vector2(0,0)
	


func move_to_player():
	movement_direction = (player.global_position - global_position).normalized()
	velocity = movement_direction * speed
	move_and_slide()

func spawn_projectile():
	var new_projectile = projectile_scene.instantiate()
	new_projectile.global_position += global_position
	new_projectile.look_at(player.global_position)
	get_parent().add_child(new_projectile)

#DETECTS IF PLAYER IS IN RANGE
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("yep")
		player = body
		can_move = true
		can_shoot = true
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_move = false
		can_shoot = false

#DETECTS IF HIT BY PLAYER
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("glove"):
		hp -= area.damage
