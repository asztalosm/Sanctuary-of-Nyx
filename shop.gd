extends Node2D
@export var inrange = false
@export var ingui = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Alert.visible = true
		$AnimatedSprite2D.animation = "inrange"
		inrange = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Alert.visible = false
		$AnimatedSprite2D.animation = "default"
		inrange = true
		

func _process(_delta: float) -> void:
	if inrange and Input.is_action_just_pressed("E"):
		if !ingui:
			ingui = true
			$ShopGUI.visible = true
		else:
			ingui = false
			$ShopGUI.visible = false
