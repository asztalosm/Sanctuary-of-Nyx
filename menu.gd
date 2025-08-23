extends Control

func _ready() -> void:
	$Control/Button.grab_focus()

func showclasses():
	print("should show classes")


func _on_button_pressed() -> void:
	#todo: make this be saved locally, idc that the browser probably won't hold the save
	var buttontween = get_tree().create_tween()
	buttontween.set_parallel(true)
	buttontween.tween_property($Control, "modulate:a", 0, 1.0)
	buttontween.tween_property($RichTextLabel, "modulate:a", 0, 1.0)
	buttontween.play()
	await get_tree().create_timer(1.0).timeout
	$Camera2D.position.x += 400
	await get_tree().create_timer(1.0).timeout
	showclasses()
