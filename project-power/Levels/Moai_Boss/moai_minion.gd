extends CharacterBody2D

@export var facing_right : bool = false 
@export var move_speed : = 100
var in_movement : bool


func _ready() -> void:
	$RayCast2D.player_detected.connect(_on_player_detected)


func _physics_process(delta: float) -> void:
	
	move_and_slide()

func start_movement():
	$AnimationPlayer.play("charge_up")
	if facing_right:
		velocity = Vector2(1,0) * move_speed
	elif !facing_right:
		velocity = Vector2(-1,0) * move_speed

func _on_player_detected():
	if !in_movement:
		start_movement()
		in_movement = true
