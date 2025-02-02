extends CharacterBody2D

var phase_zero_hp = 40
var current_phase = 1
var phase_one_distance = 10
var speed = 50
var new_direction
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_direction = Vector2(randf_range(-1,1), randf_range(-1,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if phase_zero_hp <= 0 && current_phase == 0:
		current_phase = 1
		change_direction()
	
	if current_phase == 0:
		pass
	elif current_phase == 1:
		phase_one_update()
		
func phase_one_update():
	#var new_direction = Vector2(randf_range(0,1), randf_range(0,1))
	velocity = new_direction * speed 
	print(new_direction)
	move_and_slide()
	
func change_direction():
	while current_phase == 1:
		await get_tree().create_timer(2).timeout
		new_direction = Vector2(randf_range(-1,1), randf_range(-1,1))
