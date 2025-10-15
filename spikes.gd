extends Area2D

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.hit(2.0, false)
	else:
		body.health -= 2.0
		body.get_node("AnimationPlayer").play("hit")
