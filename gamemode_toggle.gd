extends TextureButton


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$RichTextLabel3.text = "Arcade"
		get_parent().get_parent().startscene = "res://arcade.tscn"
	else:
		$RichTextLabel3.text = "Campaign"
		get_parent().get_parent().startscene = "res://testplace.tscn"
