extends Area2D
@export var backtomenu = false


func _on_body_entered(_body: Node2D) -> void:
	$Sprite2D/Outline.get_material().set_shader_parameter("inarea", true)
	if get_parent().name == "Tutorial":
		backtomenu = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("E"):
		if backtomenu:
			get_tree().change_scene_to_file("res://menu.tscn")


func _on_body_exited(body: Node2D) -> void:
	$Sprite2D/Outline.get_material().set_shader_parameter("inarea", true)
	if get_parent().name == "Tutorial":
			backtomenu = false
