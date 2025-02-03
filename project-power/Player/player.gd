extends CharacterBody2D


@export_group("Player Stats") 
@export var speed := 400.0
@export var hp : float = 100
var original_modulate := get_modulate()
@export var damage := 1
@export var knockback_power = 300
@onready var power_meter_snere_sound: AudioStreamPlayer2D = $Power_Meter_snere_sound
@onready var power_mete_bell_sound: AudioStreamPlayer2D = $Power_mete_bell_sound
@onready var atack_sound: AudioStreamPlayer2D = $Atack_Sound
@onready var take_damage_sund: AudioStreamPlayer2D = $Take_damage_sund
@onready var game_over_voice: AudioStreamPlayer2D = $Game_over_voice
@onready var game_over_sound: AudioStreamPlayer2D = $Game_over_sound
@onready var upgrade_sound: AudioStreamPlayer2D = $Upgrade_sound
@onready var music_sound: AudioStreamPlayer2D = $Music_sound
@onready var win_sound: AudioStreamPlayer2D = $Win_sound

@export var fire_glove_texture: CompressedTexture2D
@export var shield_glove_texture: CompressedTexture2D


@export var right_power = 0
@export var right_power_current_treshold = 0
@export var left_power = 0
@export var left_power_current_treshold = 0
@export var max_power = 100
@export var power_gain_speed = 0.2
@export var power_gain_amount = 10
@export var power_buffor_time = 0.2
@export var special_ability_power_threshold = 50

var first_power_threshold = 10
var second_power_threshold = 20
var third_power_threshold = 50
var forth_power_threshold = 90



var is_charging = false
var fire_glove = false
var shield_glove = false
@export_group("Projectiles")
@export var projectile_scene = PackedScene
var shield_scene = preload("res://Player/Shield.tscn")

@onready var health_bar = $CanvasLayer/Health_Bar
var shield_spawn_distance = 250

var playerDead = false;

func _ready() -> void:
	$CanvasLayer/Left_Meter/l_progressBar.max_value = max_power
	$CanvasLayer/Right_Meter/r_progressBar2.max_value = max_power
	health_bar.max_value = hp
	health_bar.value = hp
	shield_glove = get_parent().get_node("player_upgrades_data").shield_glove
	fire_glove = get_parent().get_node("player_upgrades_data").fire_glove
	music_sound.play()
	
	if fire_glove == true:
		get_child(2).get_child(0).get_child(0).texture = fire_glove_texture
	if shield_glove == true:
		get_child(3).get_child(0).get_child(0).texture = shield_glove_texture

func _physics_process(delta: float) -> void:
	if !music_sound.playing:
		music_sound.play()
	if !playerDead:
		var horizontal_movemoent := Input.get_axis("left", "right")
		var vertical_movement := Input.get_axis("up","down")
		
		if horizontal_movemoent or vertical_movement:
			velocity = Vector2(horizontal_movemoent, vertical_movement).normalized() * speed
		else:
			velocity = Vector2(0,0)
		
		look_at(get_global_mouse_position())
		
		$CanvasLayer/Right_Meter/r_progressBar2.value = right_power
		$CanvasLayer/Left_Meter/l_progressBar.value = left_power
		
		if Input.is_action_just_pressed("right_click"):
			is_charging = true
			start_right_power_gain()
			$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("charge_up_windup_anim")
			$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("charge_up_loop_anim")
		if Input.is_action_just_released("right_click"):
			is_charging = false
			reset_right_power_with_buffor()
			$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("right_glove_anim")
			atack_sound.play()
			if fire_glove == true && right_power >= special_ability_power_threshold:
				$Projectile_Spawner.spawn_projectile(get_global_mouse_position(), 1)
			
		if Input.is_action_just_pressed("left_click"):
			is_charging = true
			start_left_power_gain()
			$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.play("charge_up_windup_anim")
			$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.play("charge_up_loop_anim")
		if Input.is_action_just_released("left_click"):
			is_charging = false
			reset_left_power_with_buffor()
			$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.play("right_glove_anim")
			atack_sound.play()
			if shield_glove == true && left_power >= special_ability_power_threshold:
				var new_shield = shield_scene.instantiate()
				new_shield.global_position = (global_position + (get_global_mouse_position() - 
				global_position).normalized() * shield_spawn_distance)
				new_shield.global_rotation = global_rotation
				get_parent().add_child(new_shield)
			
			
		if Input.is_action_just_released("esc"):
			if $Esc_Canvas.visible == true:
				$Esc_Canvas.hide()
			elif $Esc_Canvas.visible == false:
				$Esc_Canvas.show()
			
		move_and_slide()

		
func start_right_power_gain():
	var current_threshold = 0
	while is_charging && right_power < max_power:
		right_power += power_gain_amount
		if right_power >= first_power_threshold && current_threshold == 0:
			current_threshold = 1
			right_power_current_treshold = 1
			$CanvasLayer/Right_Meter/AnimationPlayer.play("power_meter_number_1_enter_anim")
			power_meter_snere_sound.pitch_scale = 1
			power_meter_snere_sound.play()
		if right_power >= second_power_threshold && current_threshold == 1:
			current_threshold = 2 
			right_power_current_treshold = 2
			$CanvasLayer/Right_Meter/AnimationPlayer.play("power_meter_number_2_enter_anim")
			power_meter_snere_sound.pitch_scale += 0.1
			power_meter_snere_sound.play()
		if right_power >= third_power_threshold && current_threshold == 2:
			current_threshold = 3
			right_power_current_treshold = 3
			$CanvasLayer/Right_Meter/AnimationPlayer.play("power_meter_number_3_enter_anim")
			power_meter_snere_sound.pitch_scale += 0.1
			power_meter_snere_sound.play()
		if right_power >= forth_power_threshold && current_threshold == 3:
			current_threshold = 4
			right_power_current_treshold = 4
			$CanvasLayer/Right_Meter/AnimationPlayer.play("power_Meter_number_4_enter_anim")
			power_meter_snere_sound.pitch_scale += 0.2
			power_meter_snere_sound.play()
			power_mete_bell_sound.play()
		await get_tree().create_timer(power_gain_speed).timeout
		
func start_left_power_gain():
	var current_threshold = 0
	while is_charging && left_power < max_power:
		left_power += power_gain_amount
		if left_power >= first_power_threshold && current_threshold == 0:
			current_threshold = 1
			left_power_current_treshold = 1
			$CanvasLayer/Left_Meter/AnimationPlayer.play("power_meter_number_1_enter_anim")
			power_meter_snere_sound.pitch_scale = 1
			power_meter_snere_sound.play()
		if left_power >= second_power_threshold && current_threshold == 1:
			current_threshold = 2 
			left_power_current_treshold = 2
			$CanvasLayer/Left_Meter/AnimationPlayer.play("power_meter_number_2_enter_anim")
			power_meter_snere_sound.pitch_scale += 0.1
			power_meter_snere_sound.play()
		if left_power >= third_power_threshold && current_threshold == 2:
			current_threshold = 3
			left_power_current_treshold = 3
			$CanvasLayer/Left_Meter/AnimationPlayer.play("power_meter_number_3_enter_anim")
			power_meter_snere_sound.pitch_scale += 0.1
			power_meter_snere_sound.play()
		if left_power >= forth_power_threshold && current_threshold == 3:
			current_threshold = 4
			left_power_current_treshold = 4
			$CanvasLayer/Left_Meter/AnimationPlayer.play("power_Meter_number_4_enter_anim")
			power_meter_snere_sound.pitch_scale += 0.2
			power_meter_snere_sound.play()
			power_mete_bell_sound.play()
			
		await get_tree().create_timer(power_gain_speed).timeout
		
func reset_right_power_with_buffor():
	await get_tree().create_timer(power_buffor_time).timeout
	right_power = 0
	right_power_current_treshold = 0
	
func reset_left_power_with_buffor():
	await get_tree().create_timer(power_buffor_time).timeout
	left_power = 0
	left_power_current_treshold = 0


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("fire_area"):
		take_damage(area.damage_per_second)
	elif area.is_in_group("laser"):
		take_damage(area.damage)
	elif area.owner:
		if area.owner.damage:
			take_damage(area.owner.damage)
	elif area.damage:
		take_damage(area.damage)
	else:
		print("passed " , str(area))

func take_damage(amount):
	if !playerDead:
		hp -= amount
		health_bar.value = hp
		take_damage_sund.play()
		if hp <= 0 && !playerDead:
			game_over_sound.play()
			game_over_voice.play()
			$GameOverCanvas.show()
			$GameOverCanvas/AnimationPlayer.play("game_over_srceen_anim")
			playerDead = true
		print("current hp " + str(hp))
		set_modulate("red")
		
		#camera shake and red color below
		var camera_shake = amount *  10
		var tween = get_tree().create_tween()
		for i in 3:
			var random_offset = Vector2(randi_range(-camera_shake,camera_shake),randi_range(-camera_shake,camera_shake))
			await tween.tween_property($Camera2D,"offset", random_offset, 0.05)
		tween.tween_property($Camera2D,"offset", Vector2(0,0), 0.05)
		
		set_modulate(original_modulate)


func _on_ok_button_down() -> void:
	$Power_up_canvas.hide()


func _on_right_glove_body_entered(body: Node2D):
	if body.is_in_group("walls"):
		if $Right_Glove_Position/RightGlove/RG_AnimationPlayer.current_animation == "right_glove_anim":
			$Right_Glove_Position/RightGlove/RG_AnimationPlayer.stop()
	elif body.is_in_group("moai_enemy"):
		if $Right_Glove_Position/RightGlove/RG_AnimationPlayer.current_animation == "right_glove_anim":
			$Right_Glove_Position/RightGlove/RG_AnimationPlayer.stop()
func _on_left_glove_body_entered(body: Node2D):
	if body.is_in_group("walls"):
		if $Left_Glove_Position/LeftGlove/LG_AnimationPlayer.current_animation == "right_glove_anim":
			$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.stop()
	elif body.is_in_group("moai_enemy"):
		if $Left_Glove_Position/LeftGlove/LG_AnimationPlayer.current_animation == "right_glove_anim":
			$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.stop()
