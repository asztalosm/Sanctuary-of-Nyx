extends Control


func _ready() -> void:
	var floatTween = get_tree().create_tween()
	floatTween.tween_property(self, "global_position", self.global_position + Vector2(randi_range(-4, 4), randi_range(-12, -16)), 1.0)
	floatTween.tween_property(self, "modulate", Color8(255, 255, 255, 0), 1.0)
	await get_tree().create_timer(1.5).timeout
	queue_free()
