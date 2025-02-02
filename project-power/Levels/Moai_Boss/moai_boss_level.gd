extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$moai_minions/moai_minion.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion2.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion3.minion_took_damage.connect(_on_minion_took_damage)
	$moai_minions/moai_minion4.minion_took_damage.connect(_on_minion_took_damage)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_minion_took_damage(damage):
	$moai_boss.take_damage(damage)
