extends Node2D

var dummy = preload("res://enemy_dummy.tscn")

func _on_timer_timeout() -> void:
	var enemy = dummy.instantiate()
	add_child(enemy)
	enemy.global_position = Vector2(randi_range(120, 200), randi_range(-100,100))
