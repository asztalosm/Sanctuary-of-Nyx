extends Control
var onclassesscreen = false
func _ready() -> void:
	$Buttons/Button.grab_focus()
	await get_tree().create_timer(1).timeout
	$MenuMusic.play()
	
func showclasses():
	for children in $Classes/Buttons.get_children():
		var classtween = get_tree().create_tween()
		classtween.tween_property(children, "modulate:a", 1, 0.25)
		await classtween.finished
		release_focus()
		$Classes/Button.grab_focus()
		


func _on_button_pressed() -> void:
	if onclassesscreen == true:
		return
	else:
		$Buttons/Button/AudioStreamPlayer2D.play()
		onclassesscreen = true
		#todo: make this be saved locally, idc that the browser probably won't hold the save
		var buttontween = get_tree().create_tween()
		buttontween.set_parallel(true)
		buttontween.tween_property($Buttons, "modulate:a", 0, 1.0)
		buttontween.tween_property($RichTextLabel, "modulate:a", 0, 1.0)
		buttontween.play()
		await get_tree().create_timer(1.0).timeout
		$Camera2D.position.x += 800
		await get_tree().create_timer(1.0).timeout
		showclasses()


func _playgame() -> void:
	get_tree().change_scene_to_file("testplace.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()
