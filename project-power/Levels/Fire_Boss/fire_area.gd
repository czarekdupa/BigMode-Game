extends Area2D

@export var damage_per_second : int = 2
var deal_damage = false
var current_player : CharacterBody2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		current_player = area.owner
		area.owner.take_damage(damage_per_second)
		print("took " + str(damage_per_second) + " damage from" + $".".name)
		$Timer.start()

func _on_area_exited(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		current_player = null
		$Timer.stop()
	

func _on_timer_timeout() -> void:
	current_player.take_damage(damage_per_second)
	print("took " + str(damage_per_second) + " damage from" + $".".name)
