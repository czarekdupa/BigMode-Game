extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0

var knockback_power = 1000

func _physics_process(delta: float) -> void:
		
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal_movemoent := Input.get_axis("left", "right")
	var vertical_movement := Input.get_axis("up","down")
	
	if horizontal_movemoent or vertical_movement:
		velocity = Vector2(horizontal_movemoent, vertical_movement).normalized() * SPEED
	else:
		velocity = Vector2(0,0)
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("right_click"):
		$Right_Glove_Position/RightGlove/RG_AnimationPlayer.stop()
		$Right_Glove_Position/RightGlove/RG_AnimationPlayer.play("right_glove_anim")
		collisionHandler(1)
		#needs to be changed if time allows
		#await get_tree().create_timer($Right_Glove_Position/RightGlove/RG_AnimationPlayer.current_animation_length - 0.2).timeout
		#$Right_Glove_Position/RightGlove/Area2D.set_collision_layer(0)
		
	if Input.is_action_just_pressed("left_click"):
		$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.stop()
		$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.play("right_glove_anim")
		collisionHandler(2)
		#needs to be changed if time allows
		#await get_tree().create_timer($Left_Glove_Position/LeftGlove/LG_AnimationPlayer.current_animation_length - 0.2).timeout
		#$Left_Glove_Position/LeftGlove/Area2D.set_collision_layer(0)
	
	move_and_slide()

func collisionHandler(glove: int):
	if glove == 1:
		await get_tree().create_timer(0.233).timeout
		$Right_Glove_Position/RightGlove/Area2D.set_collision_layer(2)
		await get_tree().create_timer(0.05).timeout
		$Right_Glove_Position/RightGlove/Area2D.set_collision_layer(0)
	else:
		await get_tree().create_timer(0.233).timeout
		$Left_Glove_Position/LeftGlove/Area2D.set_collision_layer(2)
		await get_tree().create_timer(0.05).timeout
		$Left_Glove_Position/LeftGlove/Area2D.set_collision_layer(0)
