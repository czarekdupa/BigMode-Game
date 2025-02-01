extends Area2D

@export var speed = 500
@export var damage = 1

var time_since_spawn : int

func _process(delta):
	position += transform.x * speed * delta
	


func _on_body_entered(_body: Node2D) -> void:
	queue_free()

#autostarted
func _on_death_timer_timeout() -> void:
	queue_free()
