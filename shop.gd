extends Node2D
@export var inrange = false
@export var ingui = false
@export var shopitems = [
	{"Title": "Sharper blades",
	"Description": "Swords deal 50% more damage.",
	"Cost": 80},
	{"Title": "sample title 1",
	"Description": "sample description 1",
	"Cost": 1},
	{"Title": "sample title 2",
	"Description": "sample description 2",
	"Cost": 2},
	{"Title": "sample title 3",
	"Description": "sample description 3",
	"Cost": 3}
]
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
