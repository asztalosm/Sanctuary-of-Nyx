extends Control


func _on_gamemode_toggle_2_pressed() -> void:
	MenuMusic.stream = load("res://resources/soundtrack/arcade-boss-funk-type-beat-378908.mp3")
	MenuMusic.play()
	get_tree().change_scene_to_file("res://tutorial.tscn")


func _on_gamemode_toggle_pressed() -> void:
	MenuMusic.stream = load("res://resources/soundtrack/arcade-boss-funk-type-beat-378908.mp3")
	MenuMusic.play()
	get_tree().change_scene_to_file("res://arcade.tscn")

func _on_gamemode_toggle_3_pressed() -> void:
	MenuMusic.stream = load("res://resources/soundtrack/arcade-boss-funk-type-beat-378908.mp3")
	MenuMusic.play()
	get_tree().change_scene_to_file("res://dungeon.tscn")
