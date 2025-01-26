extends Node2D

var projectile_scene : PackedScene

func _ready():
	projectile_scene = $"..".projectile_scene

func spawn_projectile(player, number = 1):
	if player:
		instance_projectiles(player, number)
	else:
		pass

func instance_projectiles(player_position, number = 1):
		if number == 1 or number == 3:  
			var new_projectile = projectile_scene.instantiate()
			new_projectile.global_position = global_position
			new_projectile.look_at(player_position)
			get_parent().get_parent().add_child(new_projectile)
		if number == 2 or number == 3:
			var new_projectile = projectile_scene.instantiate()
			new_projectile.global_position += global_position
			new_projectile.look_at(player_position)
			new_projectile.rotation += deg_to_rad(15)
			get_parent().get_parent().add_child(new_projectile)
		if number == 2 or number == 3:
			var new_projectile = projectile_scene.instantiate()
			new_projectile.global_position += global_position
			new_projectile.look_at(player_position)
			new_projectile.rotation += deg_to_rad(-15)
			get_parent().get_parent().add_child(new_projectile)
