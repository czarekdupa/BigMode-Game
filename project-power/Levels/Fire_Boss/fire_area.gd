extends Area2D

@export var damage_per_second : int = 2
@export var heal_per_second : float = 0.05
var deal_damage = false
var current_player : CharacterBody2D
var default_particles : Dictionary = {}
var boss = CharacterBody2D
var has_boss = false

func _ready() -> void:
	damage_per_second = damage_per_second * $Timer .wait_time
	#sets default_particles
	default_particles.spread = $fire_particles.spread
	default_particles.speed_scale = $fire_particles.speed_scale
	default_particles.life_time = $fire_particles.lifetime
	default_particles.amount = $fire_particles.amount
	
func _process(delta: float) -> void:
	if has_boss:
		$fire_particles.direction = (boss.global_position - global_position).normalized()

func _on_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		current_player = area.owner
		area.owner.take_damage(damage_per_second)
		$Timer.start()

func _on_area_exited(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		current_player = null
		$Timer.stop()

func _on_timer_timeout() -> void:
	current_player.take_damage(damage_per_second)
	print("took " + str(damage_per_second) + " damage from" + $".".name)
	
func _on_heal_timer_timeout() -> void:
	#heals boss
	if boss:
		boss.heal_health(heal_per_second/ $heal_timer.wait_time)

#boss detection
func _on_boss_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("boss"):
		$fire_particles.spread = 10
		$fire_particles.speed_scale = 7
		$fire_particles.lifetime = 12
		$fire_particles.amount = 200
		boss = body
		has_boss = true
		
		$heal_timer.start()

func _on_boss_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("boss"):
		has_boss = false
		$fire_particles.spread = default_particles.spread
		$fire_particles.speed_scale = default_particles.speed_scale
		$fire_particles.lifetime = default_particles.life_time
		$fire_particles.amount = default_particles.amount
		
		$heal_timer.stop()
