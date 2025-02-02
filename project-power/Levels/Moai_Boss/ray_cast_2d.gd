extends RayCast2D
signal player_detected




func _process(delta) -> void:
	if get_collider():
		emit_signal("player_detected")
