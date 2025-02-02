extends CharacterBody2D
var hp = 100

func _ready():
	$CanvasLayer/Health_Bar.value = hp
	$CanvasLayer/Health_Bar.max_value = hp


func _physics_process(delta: float) -> void:

	move_and_slide()


func take_damage(damage):
	hp -=damage
	$CanvasLayer/Health_Bar.value = hp
