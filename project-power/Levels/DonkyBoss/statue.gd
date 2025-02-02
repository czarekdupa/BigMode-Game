extends Sprite2D

@export var projectile_scene: PackedScene
@export var shooting_velctor: Vector2
var can_shoot = true
var fire_rate = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_shoot:
		$Projectile_Spawner.spawn_projectile(global_position + shooting_velctor, 1)
		can_shoot = false
		shoot_time()

func shoot_time():
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true;
