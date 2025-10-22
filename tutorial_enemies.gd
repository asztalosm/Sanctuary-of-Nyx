extends Node2D
var activated = false

func _process(_delta: float) -> void:
	if get_child_count() == 0 and !activated:
		activated = true
		get_parent().get_node("Collisions").get_node("StaticBody2D6").queue_free()
		get_parent().get_node("Overlay").canProgress()
		
