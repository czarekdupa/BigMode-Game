extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0

var hp = 10
var knockback_power = 1000
var damage = 1
var right_power = 0
var left_power = 0
var max_power = 100
var power_gain_speed = 0.2
var power_gain_amount = 0.5
var is_charging = false
var power_buffor_time = 0.2
var special_ability_power_threshold = 3

var fire_glove = false

@export var projectile_scene = PackedScene

func _ready() -> void:
	$CanvasLayer/l_progressBar.max_value = max_power
	$CanvasLayer/r_progressBar2.max_value = max_power

func _physics_process(delta: float) -> void:
	
	var horizontal_movemoent := Input.get_axis("left", "right")
	var vertical_movement := Input.get_axis("up","down")
	
	if horizontal_movemoent or vertical_movement:
		velocity = Vector2(horizontal_movemoent, vertical_movement).normalized() * SPEED
	else:
		velocity = Vector2(0,0)
	
	look_at(get_global_mouse_position())
	
	$CanvasLayer/r_progressBar2.value = right_power
	$CanvasLayer/l_progressBar.value = left_power
	
	if Input.is_action_just_pressed("right_click"):
		is_charging = true
		start_right_power_gain()
		$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("charge_up_windup_anim")
		await get_tree().create_timer($Right_Glove_Position/RightGlove/RG_AnimationPlayer.current_animation_length).timeout
		$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("charge_up_loop_anim")
	if Input.is_action_just_released("right_click"):
		is_charging = false
		reset_right_power_with_buffor()
		#$Right_Glove_Position/RightGlove/RG_AnimationPlayer.stop()
		$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("right_glove_anim")
		if fire_glove == true && right_power >= special_ability_power_threshold:
			$Projectile_Spawner.spawn_projectile(get_global_mouse_position(), 1)
		collisionHandler(1)
		
	if Input.is_action_just_pressed("left_click"):
		is_charging = true
		start_left_power_gain()
		$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.play("charge_up_windup_anim")
		await get_tree().create_timer($Left_Glove_Position/LeftGlove/LG_AnimationPlayer.current_animation_length).timeout
		$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.play("charge_up_loop_anim")
	if Input.is_action_just_released("left_click"):
		is_charging = false
		reset_left_power_with_buffor()
		#$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.stop()
		$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.play("right_glove_anim")
		collisionHandler(2)
		
	move_and_slide()

func collisionHandler(glove: int):
	if glove == 1:
		await get_tree().create_timer(0.0333).timeout
		$Right_Glove_Position/RightGlove.set_collision_layer(2)
		await get_tree().create_timer(0.05).timeout
		$Right_Glove_Position/RightGlove.set_collision_layer(0)
	else:
		await get_tree().create_timer(0.0333).timeout
		$Left_Glove_Position/LeftGlove.set_collision_layer(2)
		await get_tree().create_timer(0.05).timeout
		$Left_Glove_Position/LeftGlove.set_collision_layer(0)
		
func start_right_power_gain():
	while is_charging:
		right_power += power_gain_amount
		await get_tree().create_timer(power_gain_speed).timeout
		
func start_left_power_gain():
	while is_charging:
		left_power += power_gain_amount
		await get_tree().create_timer(power_gain_speed).timeout
		
func reset_right_power_with_buffor():
	await get_tree().create_timer(power_buffor_time).timeout
	right_power = 0
	
func reset_left_power_with_buffor():
	await get_tree().create_timer(power_buffor_time).timeout
	left_power = 0


func _on_area_2d_area_entered(area: Area2D) -> void:
	hp -= 1
	print(hp)


func _on_area_2d_body_entered(body: Node2D) -> void:
	hp -= 1
	print(hp)
