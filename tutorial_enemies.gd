extends Node2D
var activated = false

func _process(_delta: float) -> void:
	if get_child_count() == 0 and !activated:
		get_parent().get_node("Collisions").get_node("StaticBody2D6")
		get_parent().get_node("Overlay").canProgress()
		activated = true
