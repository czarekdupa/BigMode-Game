extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0


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
	
	if Input.is_action_just_pressed("left_click"):
		$Left_Glove_Position/LeftGlove/LG_AnimationPlayer.play("right_glove_anim")
		
	move_and_slide()
