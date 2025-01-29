extends CharacterBody2D

@export var hp : = 10
@export var damage := 1
@export var knockback_cooldown: = 0.2
const SPEED = 300
const JUMP_VELOCITY = -400.0
var movement_direction : Vector2
var can_move : bool
var player: CharacterBody2D
var player_global_position : Vector2
var is_knocking: bool
var knockback_power: float
var original_color =  get_modulate()

func _physics_process(delta: float) -> void:
	if player:
		player_global_position = player.global_position
		look_at(player_global_position)
		
	
	if is_knocking == false:
		if can_move:
			velocity += (player_global_position - global_position).normalized() * SPEED * delta
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(self,"velocity", Vector2(0,0), 0.5)
		
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		movement_direction = (body.global_position - global_position).normalized()
		player = body
		can_move = true
	else:
		pass

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_move = false
	else:
		pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	is_knocking = true
	if area.is_in_group("r_glove"):
		velocity = (global_position - player_global_position).normalized() * area.owner.knockback_power * area.get_parent().get_parent().right_power
		take_damage(area.get_parent().get_parent().damage * area.owner.right_power)
	elif area.is_in_group("l_glove"):
		velocity = (global_position - player_global_position).normalized() * area.owner.knockback_power * area.get_parent().get_parent().left_power
		take_damage(area.owner.damage * area.owner.left_power)
	elif area.is_in_group("glove"):
		take_damage(area.damage)
	_knockback_Cooldown(knockback_cooldown)
	
func _knockback_Cooldown(time: float):
	await get_tree().create_timer(time).timeout
	is_knocking = false;
	var tween = get_tree().create_tween()
	tween.tween_property(self,"velocity", Vector2(0,0), 0.2)

func take_damage(amount: int):
	hp -= amount
		#changes color
	set_modulate("red")
	await get_tree().create_timer(0.2).timeout
	if hp <= 0:
		queue_free()
	set_modulate(original_color)
	
func _on_attack_box_area_entered(area: Area2D) -> void:
	pass
