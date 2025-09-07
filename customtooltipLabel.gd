extends Button
@export var used_text = "text that will be replaced from a json file with data about the item"


func _make_custom_tooltip(_for_text: String) -> Object:
	var tooltiplabel : RichTextLabel = RichTextLabel.new()
	tooltiplabel.bbcode_enabled = true
	tooltiplabel.text = used_text
	tooltiplabel.theme = preload("res://resources/shaders/inventorytooltip.tres")
	var lines = 1
	if used_text.count("[p]") > 0:
		lines = used_text.count("[p]") +1
	tooltiplabel.custom_minimum_size = Vector2(256, lines*18)
	return tooltiplabel
