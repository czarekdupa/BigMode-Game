extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$moai_minions/moai_minion.minion_took_damage.connect(_on_minion_took_damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_minion_took_damage(damage):
	$moai_boss.take_damage(damage)
