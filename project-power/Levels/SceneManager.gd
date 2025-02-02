extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Levels/MainMenu/MainMenu.tscn")


func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://Levels/Fire_Boss/fire_boss_level.tscn")


func _on_quit_button_down() -> void:
	get_tree().quit()


func _on_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://Levels/MainMenu/MainMenu.tscn")


func _on_next_level_button_down() -> void:
	get_tree().change_scene_to_file("res://Levels/Moai_Boss/moai_boss_level.tscn")



func _on_next_boss_2_button_down() -> void:
	get_tree().change_scene_to_file("res://Levels/DonkyBoss/Last_boss_level.tscn")


func _on_main_menu_from_win_button_down() -> void:
	get_tree().change_scene_to_file("res://Levels/MainMenu/MainMenu.tscn")
