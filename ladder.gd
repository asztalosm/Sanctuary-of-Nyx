extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.global_position = get_parent().get_node("teleport" + name.erase(0,6)).global_position
