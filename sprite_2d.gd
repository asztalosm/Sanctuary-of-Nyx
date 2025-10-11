extends Sprite2D
@export var target = self


func _on_timer_timeout() -> void:
	var arrowscene = preload("res://arrow.tscn")
	var arrowinstance = arrowscene.instantiate()
	arrowinstance.global_position = global_position
	add_child(arrowinstance)
	arrowinstance.rotation = 0
	arrowinstance.dir = Vector2(0, 1)
