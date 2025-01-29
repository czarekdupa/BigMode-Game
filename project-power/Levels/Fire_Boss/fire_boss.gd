extends CharacterBody2D

@export_category("Stats")
@export var hp := 3
@onready var health_bar = $CanvasLayer/Health_Bar
@export var speed = 300
@export var projectile_scene: PackedScene
@export var keep_distance := 300
@export_category("Timers")
@export var fireball_timer_time := 3

var ORIGINAL_COLOR = modulate

var movement_direction : Vector2
var circle_direction = PI/2
var can_move : bool
var can_shoot : bool
var player : CharacterBody2D
	

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp

func _physics_process(delta: float) -> void:
	if player:
		look_at(player.global_position)
		#get distance sqrt(a^2 + b^2) = c
		var distance_to_player = sqrt((player.global_position.x - global_position.x)*(player.global_position.x - global_position.x)
		+(player.global_position.y - global_position.y)*(player.global_position.y - global_position.y))
		if can_move:
			movement_direction = (player.global_position - global_position).normalized()
			if distance_to_player > keep_distance + 100:
				move_to_player()
				circle_direction = PI/2
			elif distance_to_player < keep_distance - 100:
				move_away_from_player()
				circle_direction = -PI/2
			else:
				rotate_around_player(circle_direction)
			
		if can_shoot:
			var bullets = randi_range(1,3)
			$Projectile_Spawner.spawn_projectile(player.global_position, bullets)
			can_shoot = false
			$ProjectileTimer.start()
		else:
			pass
	

func move_to_player():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"velocity", movement_direction * speed * 2, 1)
	move_and_slide()
func move_away_from_player():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"velocity", -movement_direction * speed, 1)
	move_and_slide()
func rotate_around_player(direction = PI/2):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "velocity",movement_direction.rotated(direction) * speed, 0.5)
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
		if area.owner:
			take_damage(area.owner.damage)
		else:
			take_damage(area.damage)

func take_damage(damage):
	hp-= damage
	health_bar.value -= damage
	if health_bar.value >= 0:
		health_bar.show
	$Sprite2D.set_modulate("red")
	await get_tree().create_timer(0.2).timeout
	if hp <= 0:
		player.fire_glove = true
		queue_free()
	$Sprite2D.set_modulate(ORIGINAL_COLOR)
	
#physical timers-----------------------------------------------------------------------------------
func _on_projectile_timer_timeout() -> void:
	can_shoot = true
