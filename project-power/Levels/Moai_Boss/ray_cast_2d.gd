extends RayCast2D
signal player_detected




func _process(delta) -> void:
	if get_collider():
		if get_collider().is_in_group("player"):
			emit_signal("player_detected")
