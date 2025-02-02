extends CharacterBody2D

var hp = 100
var phase_zero_hp = 1
var phase_one_hp = 50
var phase_two_hp = 30
var current_phase = 0
var phase_one_distance = 10
var speed = 500
var new_direction
var player : CharacterBody2D
var ORIGINAL_COLOR = modulate
var damage = 3

@export var projectile_scene: PackedScene 
var enemy_scene = preload("res://Enemies/enemy.tscn")

var moving = true
var new_position = Vector2(0,0)

@onready var health_bar = $CanvasLayer/Health_Bar
@onready var take_damage_sound: AudioStreamPlayer2D = $"../take_damage_sound"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = phase_zero_hp
	health_bar.value = phase_zero_hp
	new_direction = Vector2(randf_range(-1,1), randf_range(-1,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if phase_zero_hp <= 0 && current_phase == 0:
		current_phase = 1
		health_bar.max_value = phase_one_hp
		health_bar.value = phase_one_hp
		get_parent().get_child(3).can_shoot = true;
		get_parent().get_child(4).can_shoot = true;
		get_parent().get_child(5).can_shoot = true;
		get_parent().get_child(6).can_shoot = true;
		change_direction()
	elif phase_one_hp <= 0 && current_phase == 1:
		current_phase = 2
		moving = true
		health_bar.max_value = phase_two_hp
		health_bar.value = phase_two_hp
		get_parent().get_child(3).can_shoot = false;
		get_parent().get_child(4).can_shoot = false;
		get_parent().get_child(5).can_shoot = false;
		get_parent().get_child(6).can_shoot = false;
		spawn_enemy()
	elif phase_two_hp <= 0 && current_phase == 2:
		current_phase = 3
		health_bar.max_value = hp
		health_bar.value = hp
		get_parent().get_child(3).can_shoot = true;
		get_parent().get_child(4).can_shoot = true;
		get_parent().get_child(5).can_shoot = true;
		get_parent().get_child(6).can_shoot = true;
		change_direction_third_phase()
		spawn_enemy()
	
	if current_phase == 0:
		pass
	elif current_phase == 1:
		phase_one_update(delta)
	elif current_phase == 2:
		phase_two_update(delta)
	elif current_phase == 3:
		phase_three_update(delta)
		
func phase_one_update(delta):
	if moving:
		global_position = global_position.move_toward(new_position, delta * speed)
	if global_position == new_position:
		moving = false
	move_and_slide()
	
func phase_two_update(delta):
	if moving:
		global_position = global_position.move_toward(get_parent().get_child(8).position, delta * speed)
	if global_position == get_parent().get_child(8).position:
		moving = false
	
	if moving == false:
		$Projectile_Spawner.spawn_projectile(player.global_position, 1)
	
	move_and_slide()
	
func phase_three_update(delta):
	if moving:
		global_position = global_position.move_toward(new_position, delta * speed)
	if global_position == new_position:
		moving = false
	move_and_slide()
	
	if moving == false:
		$Projectile_Spawner.spawn_projectile(player.global_position, 1)
	
	move_and_slide()
	
func change_direction():
	while current_phase == 1:
		await get_tree().create_timer(2).timeout
		new_position = Vector2(randf_range(get_parent().get_child(0).position.x,get_parent().get_child(1).position.x), randf_range(get_parent().get_child(0).position.y,get_parent().get_child(1).position.y))
		if current_phase == 1:
			moving = true;
			
func change_direction_third_phase():
	while current_phase == 3:
		await get_tree().create_timer(2).timeout
		new_position = Vector2(randf_range(get_parent().get_child(0).position.x,get_parent().get_child(1).position.x), randf_range(get_parent().get_child(0).position.y,get_parent().get_child(1).position.y))
		if current_phase == 3:
			moving = true;
			
func spawn_enemy():
	var enemyCount = 4
	#while current_phase == 2:
		#await get_tree().create_timer(5).timeout
		#var new_enemy = enemy_scene.instantiate()
		#new_enemy.global_position = Vector2(randf_range(get_parent().get_child(0).position.x,get_parent().get_child(1).position.x), randf_range(get_parent().get_child(0).position.y,get_parent().get_child(1).position.y))
		#get_parent().add_child(new_enemy)
	
	for i in enemyCount:
		var new_enemy = enemy_scene.instantiate()
		new_enemy.global_position = Vector2(randf_range(get_parent().get_child(0).position.x,get_parent().get_child(1).position.x), randf_range(get_parent().get_child(0).position.y,get_parent().get_child(1).position.y))
		get_parent().add_child(new_enemy)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectile"):
		if area.owner:
			take_damage(area.owner.damage)
		else:
			take_damage(area.damage)
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
	


func take_damage(damage):
	take_damage_sound.play()
	if current_phase == 0:
		phase_zero_hp -= damage
		health_bar.value = phase_zero_hp
	elif current_phase == 1:
		phase_one_hp -= damage
		health_bar.value = phase_one_hp
	elif current_phase == 2:
		phase_two_hp -= damage
		health_bar.value = phase_two_hp
	else:
		hp -= damage
		health_bar.value = hp
		if hp <= 0:
			player.fire_glove = true;
			#player.get_child(2).get_child(0).get_child(0).texture = boss_power_glove_texture
			player.get_child(11).show()
			player.get_child(11).get_child(2).play("PowerUp_enter_anim")
			await get_tree().create_timer(player.get_child(11).get_child(2).current_animation_length).timeout
			player.get_child(11).get_child(2).play("PowerUp_anim")
			queue_free()
		
	$BossSprite.set_modulate("red")
	await get_tree().create_timer(0.2).timeout
	$BossSprite.set_modulate(ORIGINAL_COLOR)
