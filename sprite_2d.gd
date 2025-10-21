extends Sprite2D
@export var target = self

func _on_timer_timeout() -> void:
	var arrowscene = preload("res://arrow.tscn")
	var arrowinstance = arrowscene.instantiate()
	arrowinstance.damage = 3.0
	arrowinstance.global_position = global_position
	add_child(arrowinstance)
	arrowinstance.rotation = 0
	var direction = Vector2.from_angle(global_position.angle_to_point($Marker2D.global_position))
	arrowinstance.dir = direction
	print(direction)
	
