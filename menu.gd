extends Control
var onclassesscreen = false
var konami = ""
func _ready() -> void:
	await get_tree().create_timer(5).timeout
	$AudioAlert.visible = false
	$Buttons/Button.grab_focus()
	await get_tree().create_timer(1).timeout
	
func showclasses():
	for children in $Classes/Buttons.get_children():
		var classtween = get_tree().create_tween()
		classtween.tween_property(children, "modulate:a", 1, 0.25)
		await classtween.finished
		release_focus()
		$Classes/Button.grab_focus()

func checkkonami() -> void:
	if konami == "uuddlrlrblae" and len(konami) == 12:
		$Shiba.visible = true
		$Shiba/AudioStreamPlayer.play()
		await get_tree().create_timer(2).timeout
		$Shiba.visible = false
	else:
		konami = ""

func _on_button_pressed() -> void:
	if onclassesscreen == true:
		return
	else:
		$MenuButton.stream = load("res://resources/menubutton.wav")
		$MenuButton.play()
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
	$MenuButton.play()
	get_tree().change_scene_to_file("testplace.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Up"): #holy spaghetti code
		konami = konami + "u"
	if Input.is_action_just_pressed("Down"):
		konami = konami + "d"
	if Input.is_action_just_pressed("Left"):
		konami = konami + "l"
	if Input.is_action_just_pressed("Right"):
		konami = konami + "r"
	if Input.is_action_just_pressed("B"):
		konami = konami + "b"
	if Input.is_action_just_pressed("a"):
		konami = konami + "a"
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE):
		konami = konami + "e"
		checkkonami()

func settings_pressed() -> void:
	$MenuButton.stream = load("res://resources/menubutton.wav")
	$MenuButton.play()
