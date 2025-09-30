extends Control


func _on_gamemode_toggle_2_pressed() -> void:
	return
	#get_tree().change_scene_to_file("res://arcade.tscn")


func _on_gamemode_toggle_pressed() -> void:
	get_tree().change_scene_to_file("res://arcade.tscn")
