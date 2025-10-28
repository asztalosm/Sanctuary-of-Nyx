extends Area2D
@export var inrange = false
@export var player = null

func _process(_delta: float) -> void:
	if inrange and Input.is_action_just_pressed("E"):
		var screentween = get_tree().create_tween()
		screentween.set_parallel(false)
		screentween.tween_property($CanvasLayer/ColorRect, "color:a", 1.0, 0.4)
		screentween.tween_property(player.get_node("Camera2D"), "position_smoothing_enabled", false, 0.0)
		screentween.tween_property(player, "global_position", get_parent().get_node("teleport" + name.erase(0,6)).global_position, 0.0)
		screentween.tween_property($CanvasLayer/ColorRect, "color:a", 0.0, 0.4)
		screentween.tween_property(player.get_node("Camera2D"), "position_smoothing_enabled", true, 0.0)
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		inrange = true
		$AnimatedSprite2D.animation = "selected2"


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inrange = false
		player = null
		$AnimatedSprite2D.animation = "default"
