extends Button
@export var used_text = "text that will be replaced from a json file with data about the item"


func _make_custom_tooltip(_for_text: String) -> Object:
	print(used_text)
	var tooltiplabel : RichTextLabel = RichTextLabel.new()
	tooltiplabel.bbcode_enabled = true
	tooltiplabel.text = used_text
	tooltiplabel.theme = preload("res://resources/shaders/inventorytooltip.tres")
	var lines = 1
	if used_text.count("[p]") > 0:
		lines = used_text.count("[p]")
	tooltiplabel.custom_minimum_size = tooltiplabel.get_theme_default_font().get_string_size(used_text) * Vector2(0.5, lines)
	return tooltiplabel
