extends Control
var onclassesscreen = false
var konami = ""
var selectedclass = ""
var musicvolume = 1.0

var startscene = "res://testplace.tscn"
func _ready() -> void:
	MenuMusic.stream = load("res://resources/trashmenumusicthatmakesmewanttoclosethegame.wav")
	MenuMusic.play()
	$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume".value = MenuMusic.musicvolume
	$"Settings/PanelContainer/MarginContainer/VBoxContainer/SFX Volume".value = MenuMusic.sfxvolume
	$Settings/PanelContainer/MarginContainer/VBoxContainer/CheckButton.button_pressed = MenuMusic.damagenumber
	$AudioAlert.visible = true
	await get_tree().create_timer(5).timeout
	var audioalertTween = get_tree().create_tween()
	audioalertTween.tween_property($AudioAlert, "modulate:a", 0.0, 0.4)
	audioalertTween.play()
	$AudioAlert.mouse_behavior_recursive = MOUSE_BEHAVIOR_DISABLED
	await audioalertTween.finished
	$AudioAlert.visible = false
	$Buttons/Button.grab_focus()

# func showclasses():
#	for children in $Classes/Buttons.get_children():
#		var classtween = get_tree().create_tween()
#		classtween.tween_property(children, "modulate:a", 1, 0.25)
#		await classtween.finished
#		release_focus()
#		$Classes/Button.grab_focus()


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
		$Gamemode/GamemodeToggle.grab_focus()
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
		#showclasses()

func _playgame() -> void:
	$MenuButton.play()
	get_tree().change_scene_to_file("testplace.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	#print(MenuMusic.musicvolume)
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
		if $Settings.visible:
			var settingsTween = get_tree().create_tween()
			settingsTween.tween_property($Settings, "scale:y", 0.0, 0.3)
			await settingsTween.finished
			$Settings.visible = false
	if Input.is_action_just_pressed("a"):
		konami = konami + "a"
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE):
		konami = konami + "e"
		checkkonami()
	if Input.is_anything_pressed():
		if $AudioAlert.visible:
			$AudioAlert.mouse_behavior_recursive = MOUSE_BEHAVIOR_DISABLED
			var audioalertTween = get_tree().create_tween()
			audioalertTween.tween_property($AudioAlert, "modulate:a", 0.0, 0.4)
			audioalertTween.play()
			await audioalertTween.finished
			$AudioAlert.visible = false
			$Buttons/Button.grab_focus()

func settings_pressed() -> void:
	var settingsTween = get_tree().create_tween()
	if $Settings.visible:
		settingsTween.tween_property($Settings, "scale:y", 0.0, 0.3)
		await settingsTween.finished
		$Settings.visible = false
	else:
		$Settings.visible = true
		settingsTween.tween_property($Settings, "scale:y", 1.0, 0.3)
		await settingsTween.finished
	$MenuButton.stream = load("res://resources/menubutton.wav")
	$MenuButton.play()


func startgame() -> void: #i have zero fucking ideas for why the pressed signal doesnt work but button down does
	$MenuButton.stream = load("res://resources/menubutton.wav")
	$MenuButton.play()
	get_tree().change_scene_to_file(startscene)



func _on_music_volume_value_changed(value: float) -> void:
	MenuMusic.musicvolume = value


func _on_sfx_volume_value_changed(value: float) -> void:
	MenuMusic.sfxvolume = value




func _on_check_button_pressed() -> void:
	if $Settings/PanelContainer/MarginContainer/VBoxContainer/CheckButton.button_pressed:
		MenuMusic.damagenumber = true
	else:
		MenuMusic.damagenumber = false
