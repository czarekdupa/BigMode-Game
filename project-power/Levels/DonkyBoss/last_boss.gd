extends CharacterBody2D

var hp = 100
var phase_zero_hp = 1
var current_phase = 0
var phase_one_distance = 10
var speed = 500
var new_direction
var player : CharacterBody2D
var ORIGINAL_COLOR = modulate
var damage = 1

@onready var health_bar = $CanvasLayer/Health_Bar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = hp
	health_bar.value = hp
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

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("r_glove"):
		if area.owner:
			take_damage(area.owner.damage * area.owner.right_power)
		else:
			take_damage(area.damage)
	if area.is_in_group("l_glove"):
		if area.owner:
			take_damage(area.owner.damage * area.owner.left_power)
		else:
			take_damage(area.damage)


func take_damage(damage):
	if current_phase == 0:
		phase_zero_hp -= damage
	else:
		hp -= damage
		health_bar.value = hp
		if hp <= 0:
			player.fire_glove = true;
			Sprite2D
			#player.get_child(2).get_child(0).get_child(0).texture = boss_power_glove_texture
			player.get_child(11).show()
			player.get_child(11).get_child(2).play("PowerUp_enter_anim")
			await get_tree().create_timer(player.get_child(11).get_child(2).current_animation_length).timeout
			player.get_child(11).get_child(2).play("PowerUp_anim")
			queue_free()
		
	$BossSprite.set_modulate("red")
	await get_tree().create_timer(0.2).timeout
	$BossSprite.set_modulate(ORIGINAL_COLOR)
