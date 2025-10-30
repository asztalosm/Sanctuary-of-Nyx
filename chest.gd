extends Area2D
@export var inarea = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatedSprite2D.animation = "inrange"
		inarea = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatedSprite2D.animation = "default"
		inarea = false

func _process(_delta: float) -> void:
	if inarea and Input.is_action_just_pressed("E"):
		get_parent().get_parent().coins += randi_range(100,150)
		queue_free()
