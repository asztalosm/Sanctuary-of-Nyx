extends CanvasLayer

func _ready() -> void:
	get_parent().get_node("Character").get_node("Player").pausable = false
	visible = true
	if TranslationServer.get_locale() == "jp":
		$RichTextLabel.text = "[font_size=17]" + tr("MENU_ARCADE") + "[br]" + tr("MODEDESC")
	else:
		$RichTextLabel.text = "[font_size=33]" + tr("MENU_ARCADE") + "[br][font_size=16]" + tr("MODEDESC")
	$Button.grab_focus()

func _on_button_pressed() -> void:
	get_parent().get_node("Intermission").get_node("Dice").get_node("EnemyStats").grab_focus()
	queue_free()
