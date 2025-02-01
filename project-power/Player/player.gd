extends CharacterBody2D


@export_group("Player Stats") 
@export var speed := 400.0
@export var hp := 10
var original_modulate := get_modulate()
@export var damage := 1
@export var knockback_power = 1000
@export var right_power = 0
@export var left_power = 0
@export var max_power = 10
@export var power_gain_speed = 0.2
@export var power_gain_amount = 0.5
@export var power_buffor_time = 0.2
@export var special_ability_power_threshold = 3
var is_charging = false
var fire_glove = false
@export_group("Projectiles")
@export var projectile_scene = PackedScene

@onready var health_bar = $CanvasLayer/Health_Bar

var playerDead = false;

func _ready() -> void:
	$CanvasLayer/l_progressBar.max_value = max_power
	$CanvasLayer/r_progressBar2.max_value = max_power
	health_bar.max_value = hp
	health_bar.value = hp

func _physics_process(delta: float) -> void:
	
	var horizontal_movemoent := Input.get_axis("left", "right")
	var vertical_movement := Input.get_axis("up","down")
	
	if horizontal_movemoent or vertical_movement:
		velocity = Vector2(horizontal_movemoent, vertical_movement).normalized() * speed
	else:
		velocity = Vector2(0,0)
	
	look_at(get_global_mouse_position())
	
	$CanvasLayer/r_progressBar2.value = right_power
	$CanvasLayer/l_progressBar.value = left_power
	
	if Input.is_action_just_pressed("right_click"):
		is_charging = true
		start_right_power_gain()
		$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("charge_up_windup_anim")
		$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("charge_up_loop_anim")
	if Input.is_action_just_released("right_click"):
		is_charging = false
		reset_right_power_with_buffor()
		$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("right_glove_anim")
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
		
		
	if Input.is_action_just_released("esc"):
		if $Esc_Canvas.visible == true:
			$Esc_Canvas.hide()
		elif $Esc_Canvas.visible == false:
			$Esc_Canvas.show()
		
	move_and_slide()

		
func start_right_power_gain():
	while is_charging && right_power < max_power:
		right_power += power_gain_amount
		await get_tree().create_timer(power_gain_speed).timeout
		
func start_left_power_gain():
	while is_charging && left_power < max_power:
		left_power += power_gain_amount
		await get_tree().create_timer(power_gain_speed).timeout
		
func reset_right_power_with_buffor():
	await get_tree().create_timer(power_buffor_time).timeout
	right_power = 0
	
func reset_left_power_with_buffor():
	await get_tree().create_timer(power_buffor_time).timeout
	left_power = 0


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("fire_area"):
		take_damage(area.damage_per_second)
	elif area.owner:
		if area.owner.damage:
			take_damage(area.owner.damage)
	elif area.damage:
		take_damage(area.damage)
	else:
		print("passed " , str(area))

func take_damage(amount):
	hp -= amount
	health_bar.value -= damage
	if hp <= 0 && !playerDead:
		$GameOverCanvas.show()
		$GameOverCanvas/AnimationPlayer.play("game_over_srceen_anim")
		playerDead = true
	print("current hp " + str(hp))
	set_modulate("red")
	
	#camera shake and red color below
	var camera_shake = amount *  100
	var tween = get_tree().create_tween()
	for i in 3:
		var random_offset = Vector2(randi_range(-camera_shake,camera_shake),randi_range(-camera_shake,camera_shake))
		await tween.tween_property($Camera2D,"offset", random_offset, 0.05)
	tween.tween_property($Camera2D,"offset", Vector2(0,0), 0.05)
	
	set_modulate(original_modulate)


func _on_ok_button_down() -> void:
	$Power_up_canvas.hide()
