extends Area2D

@export var speed = 500
@export var damage = 1

func _process(delta):
	position += transform.x * speed * delta
	
