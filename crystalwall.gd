extends Area2D

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.hit(2.0)
