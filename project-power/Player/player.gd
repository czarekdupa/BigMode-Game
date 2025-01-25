extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal_movemoent := Input.get_axis("left", "right")
	var vertical_movement := Input.get_axis("up","down")
	
	if horizontal_movemoent or vertical_movement:
		velocity = Vector2(horizontal_movemoent, vertical_movement).normalized() * SPEED
	else:
		velocity = Vector2(0,0)
	
	move_and_slide()
