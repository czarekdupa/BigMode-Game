extends Area2D

var duration = 5.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kill_after_seconds()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func kill_after_seconds():
	await get_tree().create_timer(duration).timeout
	queue_free()
