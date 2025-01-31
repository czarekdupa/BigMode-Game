extends Area2D

@export var damage_per_second : int = 2
var deal_damage = false
var current_player : CharacterBody2D
var default_particles : Dictionary = {}

func _ready() -> void:
	damage_per_second = damage_per_second * $Timer .wait_time
	#sets default_particles
	default_particles.direction = $fire_particles.direction
	default_particles.spread = $fire_particles.spread

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



func _on_boss_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("boss"):
		$fire_particles.direction = body.global_position
		$fire_particles.spread = 10
		
#cmon
func _on_boss_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("boss"):
		for key in default_particles.keys():
			#var i = $fire_particles.get(key)
			#i = default_particles[key]
			pass
