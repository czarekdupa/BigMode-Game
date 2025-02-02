extends RayCast2D
signal wall_detected




func _process(delta) -> void:
	if get_collider():
		emit_signal("wall_detected")
