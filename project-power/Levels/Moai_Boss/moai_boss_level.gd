extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$moai_boss.final_attack_prep.connect(_on_final_attack_prep)
	$moai_boss.dead.connect(_on_dead)
	$moai_minions/moai_minion.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion2.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion3.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion4.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion5.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion6.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion7.minion_took_damage.connect(_on_minion_took_damage)
	
	
func _on_final_attack_prep():
	$moai_minions.queue_free()
	$moai_boss.final_move()


func _on_minion_took_damage(damage):
	$moai_boss.take_damage(damage)

func _on_dead():
	$Player/Power_up_canvas2.show()
