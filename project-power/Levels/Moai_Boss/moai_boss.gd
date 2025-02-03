extends AnimatableBody2D
var hp = 100
@export var move_to = Marker2D
var one_time = false
signal final_attack_prep
signal dead

func _ready():
	$CanvasLayer/Health_Bar.value = hp
	$CanvasLayer/Health_Bar.max_value = hp


func final_move():
	$shield.queue_free()
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", move_to.global_position, 2)


func take_damage(damage):
	$CPUParticles2D.emitting = true
	hp -=damage
	$CanvasLayer/Health_Bar.value = hp
	if one_time == false:
		if hp <= 10:
			emit_signal("final_attack_prep")
			one_time = true
	if hp <= 0:
		emit_signal("dead")
		queue_free()
	
func _on_hibox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectile"):
		if area.owner:
			take_damage(area.owner.damage)
		else:
			take_damage(area.damage)
	if area.is_in_group("r_glove"):
		if area.owner:
			take_damage(area.owner.damage * area.owner.right_power_current_treshold)
	if area.is_in_group("l_glove"):
		if area.owner:
			take_damage(area.owner.damage * area.owner.left_power_current_treshold)
