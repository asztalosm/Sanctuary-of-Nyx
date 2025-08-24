extends Area2D



func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent().name == "Character":
		area.get_parent().health -= 5
		$AudioStreamPlayer2D.stream = load("res://resources/hit.wav")
		$AudioStreamPlayer2D.play()
