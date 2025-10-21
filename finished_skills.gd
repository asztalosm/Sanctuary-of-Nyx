extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_parent().get_parent().get_node("Overlay").counter += 1
		get_parent().get_node("StaticBody2D4").queue_free()
		get_parent().get_parent().get_node("Overlay").canProgress()
		queue_free()
