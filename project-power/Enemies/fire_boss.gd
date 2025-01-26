extends CharacterBody2D

@export_category("Stats")
@export var hp := 3
@export var speed = 100
@export var projectile_scene: PackedScene
@export var keep_distance := 600

@export_category("Timers")
@export var fireball_timer_time := 3

var ORIGINAL_COLOR = modulate

var movement_direction : Vector2
var can_move : bool
var can_shoot : bool
var player : CharacterBody2D
	
func _physics_process(delta: float) -> void:
	#get distance sqrt(a^2 + b^2) = c
	if player:
		var distance_to_player = sqrt((player.global_position.x - global_position.x)*(player.global_position.x - global_position.x)
		+(player.global_position.y - global_position.y)*(player.global_position.y - global_position.y))
		if can_move:
			if distance_to_player > keep_distance + 100:
				move_to_player()
			elif distance_to_player < keep_distance - 100:
				move_away_from_player()
			else:
				velocity = Vector2(200,100)
				move_and_slide()
			
		if can_shoot:
			var bullets = randi_range(1,3)
			$Projectile_Spawner.spawn_projectile(player.global_position, bullets)
			can_shoot = false
			$ProjectileTimer.start()
		else:
			pass
	

func move_to_player():
	movement_direction = (player.global_position - global_position).normalized()
	velocity = movement_direction * speed
	move_and_slide()
func move_away_from_player():
	movement_direction = (player.global_position - global_position).normalized()
	velocity = -movement_direction * speed
	move_and_slide()


#DETECTS IF PLAYER IS IN RANGE
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		can_move = true
		can_shoot = true
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_move = false
		$ProjectileTimer.stop()
		can_shoot = false
		

#DETECTS IF HIT BY PLAYER
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("glove"):
		hp -= 1
	$Sprite2D.set_modulate("red")
	await get_tree().create_timer(0.2).timeout
	if hp <= 0:
		queue_free()
	$Sprite2D.set_modulate(ORIGINAL_COLOR)

#physical timers-----------------------------
func _on_projectile_timer_timeout() -> void:
	can_shoot = true
