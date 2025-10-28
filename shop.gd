extends Node2D
@export var inrange = false
@export var ingui = false
@export var shopitems = [
	{"Title": "Sharper blades",
	"Description": "Swords deal 50% more damage.",
	"Cost": 80 + randi_range(1,20)},
	{"Title": "sample title 1",
	"Description": "sample description 1",
	"Cost": randi_range(1,20)},
	{"Title": "sample title 2",
	"Description": "sample description 2",
	"Cost": randi_range(1,20)},
	{"Title": "sample title 3",
	"Description": "sample description 3",
	"Cost": randi_range(1,20)}
]
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatedSprite2D.animation = "inrange"
		inrange = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatedSprite2D.animation = "default"
		inrange = false

func _ready() -> void:
	var counter = 0
	for button in $ShopGUI/Buttons.get_children():
		
		button.get_node("Control").get_node("Title").text = shopitems[counter].Title
		button.get_node("Control").get_node("Description").text = shopitems[counter].Description
		button.get_node("Control").get_node("Cost").text = str(shopitems[counter].Cost)
		counter += 1

func _process(_delta: float) -> void:
	if inrange and Input.is_action_just_pressed("E"):
		if !ingui:
			get_tree().paused = true
			$ShopGUI/Buttons/Button.grab_focus()
			ingui = true
			$ShopGUI.visible = true
		else:
			get_tree().paused = false
			ingui = false
			$ShopGUI.visible = false


func _on_button_pressed() -> void:
	print("bought")
