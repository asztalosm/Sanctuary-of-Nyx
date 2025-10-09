extends Area2D

<<<<<<< HEAD
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.hit(2.0, false)
=======
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		area.get_parent().hit(2.0, false)
>>>>>>> c57edf9c580af921481f7f6b67192c0a8376ca79
	else:
		body.health -= 2.0
		body.get_node("AnimationPlayer").play("hit")
