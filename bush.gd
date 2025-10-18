extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_node("CollisionShape2D").set_deferred("disabled", true)
	print("area entered")


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		area.get_parent().get_node("CollisionShape2D").set_deferred("disabled", false)
		print("area exited")
