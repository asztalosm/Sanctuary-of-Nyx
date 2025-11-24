extends Node2D
@export var coins = 0
func _process(_delta: float) -> void:
	$DungeonOverlay/RichTextLabel.text = " [imgresize=16]res://resources/coin.png[color=cfa951] " + str(coins)
	if get_node_or_null("Enemies/Knight") != null:
		pass
	else:
		$DungeonOverlay/Finish.visible = true
		get_node("Character/Player").pausable = false
		$DungeonOverlay/Finish/Menu.grab_focus()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
