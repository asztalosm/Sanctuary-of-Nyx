extends StaticBody2D
var inarea = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		inarea = true
		$Sprite.animation = "inrange"


func _process(_delta: float) -> void:
	if inarea and Input.is_action_pressed("E"):
		queue_free()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Sprite.animation = "default"
		inarea = false
