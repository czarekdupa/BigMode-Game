extends AnimatableBody2D
var hp = 100
@export var move_to = Marker2D

func _ready():
	$CanvasLayer/Health_Bar.value = hp
	$CanvasLayer/Health_Bar.max_value = hp


func final_move():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", move_to.global_position, 2)


func take_damage(damage):
	hp -=damage
	$CanvasLayer/Health_Bar.value = hp
