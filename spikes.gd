extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		area.get_parent().hit(2.0, false)
	else:
		area.get_parent().health -= 2.0
