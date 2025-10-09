extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.hit(2.0, false)
	else:
		body.health -= 2.0
		body.get_node("AnimationPlayer").play("hit")
