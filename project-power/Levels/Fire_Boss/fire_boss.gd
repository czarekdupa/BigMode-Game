extends CharacterBody2D

@export_category("Stats")
@export var starting_hp : float = 50
var hp : float = starting_hp
@onready var health_bar = $CanvasLayer/Health_Bar
@export var speed = 300
var bullets : int

@export var projectile_scene: PackedScene 
@export_category("Timers")
@export var fireball_timer_time := 3
@export var boss_power_glove_texture: CompressedTexture2D
@onready var take_damage_sound: AudioStreamPlayer2D = $take_damage_sound
@onready var shooting_sound: AudioStreamPlayer2D = $Shooting_sound

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
		var keep_distance = $"Detection Area/CollisionShape2D".shape.radius
		look_at(player.global_position)
		#get distance sqrt(a^2 + b^2) = c
		var distance_to_player = sqrt((player.global_position.x - global_position.x)*(player.global_position.x - global_position.x)
		+(player.global_position.y - global_position.y)*(player.global_position.y - global_position.y))
		
		
		if can_move:
			movement_direction = (player.global_position - global_position).normalized()
			if distance_to_player > keep_distance + keep_distance/4:
				move_to_player()
				circle_direction = -circle_direction
			elif distance_to_player < keep_distance - keep_distance/4:
				move_away_from_player()
			if (keep_distance - keep_distance/4) < distance_to_player and distance_to_player < (keep_distance + keep_distance/4):
				rotate_around_player(circle_direction)
			
		if can_shoot:
			shooting_sound.play()
			$Projectile_Spawner.spawn_projectile(player.global_position, bullets)
			can_shoot = false
			$ProjectileTimer.start()
			bullets = randi_range(1,2)
		else:
			pass
	

func move_to_player():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"velocity", movement_direction * speed * 2, 0.5)
	move_and_slide()
func move_away_from_player():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"velocity", -movement_direction * speed * 0.9, 0.5)
	move_and_slide()
func rotate_around_player(direction = PI/2):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "velocity", movement_direction.rotated(direction) * speed, 1)
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
	take_damage_sound.play()
	if area.is_in_group("r_glove"):
		if area.owner:
			take_damage(area.owner.damage * area.owner.right_power_current_treshold)
		else:
			take_damage(area.damage)
	if area.is_in_group("l_glove"):
		if area.owner:
			take_damage(area.owner.damage * area.owner.left_power_current_treshold)
		else:
			take_damage(area.damage)


func heal_health(health : float):
	if hp <= starting_hp:
		hp += health
		health_bar.value = hp
	bullets = 3
	$Sprite2D.set_modulate("green")
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.set_modulate(ORIGINAL_COLOR)
	print_debug("the hp is %s " % hp)

func take_damage(damage):
	hp -= damage
	health_bar.value = hp
	$Sprite2D.set_modulate("red")
	await get_tree().create_timer(0.2).timeout
	if hp <= 0:
		player.fire_glove = true;
		Sprite2D
		player.get_child(2).get_child(0).get_child(0).texture = boss_power_glove_texture
		player.get_child(11).show()
		player.upgrade_sound.play()
		player.get_child(11).get_child(2).play("PowerUp_enter_anim")
		await get_tree().create_timer(player.get_child(11).get_child(2).current_animation_length).timeout
		player.get_child(11).get_child(2).play("PowerUp_anim")
		queue_free()
	$Sprite2D.set_modulate(ORIGINAL_COLOR)
	
#physical timers-----------------------------------------------------------------------------------
func _on_projectile_timer_timeout() -> void:
	can_shoot = true


func _on_heal_timer_timeout() -> void:
	heal_health(1)
	print_debug("timer timedout")
