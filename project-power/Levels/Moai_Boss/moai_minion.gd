extends AnimatableBody2D

var damage = 1
@export var hp:float = 20
var original_hp:float = hp
@export var move_time : = 1.5
@export var first_marker = Marker2D
@export var second_marker = Marker2D
var in_movement : bool
var velocity : Vector2
var count = 0
var going_forward = true
@onready var take_damage_sound: AudioStreamPlayer2D = $take_damage_sound
@onready var original_rotation = rotation
@onready var new_rotation = original_rotation + deg_to_rad(180)
signal minion_took_damage(damage)

func _ready() -> void:
	$PlayerDetector.player_detected.connect(_on_player_detected)
	
	
func _process(delta: float) -> void:
	
	if hp > original_hp * 2/3:
		$Sprite2D.frame = 0
	elif (original_hp * 1/3) < hp and hp <= (original_hp * 2/3):
		$Sprite2D.frame = 2
	elif 0 < hp and hp <= (original_hp * 1/3):
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 3
	



func take_damage(damage):
	take_damage_sound.play()
	hp -= damage
	emit_signal("minion_took_damage", damage)
	if hp < 0:
		$Sprite2D.frame = 3
		if $PlayerDetector:
			$PlayerDetector.queue_free()
			$attackbox.queue_free()
			$hitbox.queue_free()
			$CollisionShape2D.queue_free()
	
func start_movement():
	$AnimationPlayer.play("charge_up")
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.stop()
	move_to_area()
	

func move_to_area():
	var tween = get_tree().create_tween()
	if going_forward:
		tween.tween_property(self, "position", second_marker.global_position, move_time)
		tween.chain().tween_property(self, "rotation", new_rotation, 1.5)
		going_forward = false
	elif not going_forward:
		tween.tween_property(self, "position", first_marker.global_position, move_time)
		tween.chain().tween_property(self, "rotation", original_rotation, 1.5)
		going_forward = true
	else:
		print_debug("not moving")
	tween.chain().tween_property(self, "in_movement", false, 0.1)
	
	
func _on_player_detected():
	if in_movement == false:
		in_movement = true
		start_movement()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectile"):
		if area.owner:
			take_damage(area.owner.damage)
		else:
			take_damage(area.damage)
	if area.is_in_group("r_glove"):
		if area.owner:
			take_damage(area.owner.damage * area.owner.right_power_current_treshold)
	if area.is_in_group("l_glove"):
		if area.owner:
			take_damage(area.owner.damage * area.owner.left_power_current_treshold)
	
