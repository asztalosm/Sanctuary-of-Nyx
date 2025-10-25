extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Alert.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Alert.visible = false
