extends Control
var onclassesscreen = false
var konami = ""
var selectedclass = ""
var musicvolume = 1.0
var area = "play"

var startscene = "res://testplace.tscn"
func _ready() -> void:
	TranslationServer.set_locale("jp")
	refreshtextsize()
	MenuMusic.stream = load("res://resources/trashmenumusicthatmakesmewanttoclosethegame.wav")
	MenuMusic.play()
	$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume".value = MenuMusic.musicvolume
	$"Settings/PanelContainer/MarginContainer/VBoxContainer/SFX Volume".value = MenuMusic.sfxvolume
	$Settings/PanelContainer/MarginContainer/VBoxContainer/CheckButton.button_pressed = MenuMusic.damagenumber
	#commented$AudioAlert.visible = true
	#await get_tree().create_timer(5).timeout
	#var audioalertTween = get_tree().create_tween()
	#audioalertTween.tween_property($AudioAlert, "modulate:a", 0.0, 0.4)
	#audioalertTween.play()
	#$AudioAlert.mouse_behavior_recursive = MOUSE_BEHAVIOR_DISABLED
	#await audioalertTween.finished
	#$AudioAlert.visible = false
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
		if $Settings.visible:
			var settingsTween = get_tree().create_tween()
			settingsTween.tween_property($Settings, "scale:y", 0.0, 0.3)
			await settingsTween.finished
			$Settings.visible = false
		var buttontween = get_tree().create_tween()
		buttontween.set_parallel(true)
		buttontween.tween_property($Buttons, "modulate:a", 0, 1.0)
		buttontween.tween_property($RichTextLabel, "modulate:a", 0, 1.0)
		buttontween.play()
		area = "gamemodes"
		await get_tree().create_timer(1.0).timeout
		$Camera2D.position.x += 800
		await get_tree().create_timer(1.0).timeout
		#showclasses()

func _playgame() -> void:
	$MenuButton.play()
	get_tree().change_scene_to_file("testplace.tscn")


func areacheck() -> void:
	#this will check if the focus is outside of a certain area or not
	match area:
		"play":
			if !$Buttons/Button.has_focus() and !$Buttons/Button2.has_focus() and !$Buttons/Button3.has_focus() and !$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits/Control.visible and !$AudioAlert.visible:
				$Buttons/Button.grab_focus()
		"settings":
			if !$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume".has_focus() and !$"Settings/PanelContainer/MarginContainer/VBoxContainer/SFX Volume".has_focus() and !$"Settings/PanelContainer/MarginContainer/VBoxContainer/CheckButton".has_focus() and !$"Settings/PanelContainer/MarginContainer/VBoxContainer/Credits".has_focus() and !$"Settings/PanelContainer/MarginContainer/VBoxContainer/Change Language".has_focus() and !$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits/Control.visible and !$AudioAlert.visible:
				$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume".grab_focus()
		"gamemodes":
			if !$Gamemode/GamemodeToggle.has_focus() and !$Gamemode/GamemodeToggle2.has_focus() and !$Gamemode/GamemodeToggle3.has_focus() and !$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits/Control.visible and !$AudioAlert.visible:
				$Gamemode/GamemodeToggle.grab_focus()

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
			$Buttons/Button2.grab_focus()
			area = "play"
	if Input.is_action_just_pressed("pause"):
		if $Settings.visible:
			var settingsTween = get_tree().create_tween()
			settingsTween.tween_property($Settings, "scale:y", 0.0, 0.3)
			await settingsTween.finished
			$Settings.visible = false
			$Buttons/Button2.grab_focus()
			area = "play"
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
		if $Settings/PanelContainer/MarginContainer/VBoxContainer/Credits/Control.visible:
			$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits.disabled = false
			$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits/Control.visible = false
			$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits.grab_focus()
	

func settings_pressed() -> void:
	var settingsTween = get_tree().create_tween()
	if $Settings.visible:
		settingsTween.tween_property($Settings, "scale:y", 0.0, 0.3)
		await settingsTween.finished
		$Settings.visible = false
		area = "play"
	else:
		area = "settings"
		$Settings.visible = true
		$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume".grab_focus()
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


func _on_control_gui_input(_event: InputEvent) -> void:
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits/Control.visible = false


func _on_credits_pressed() -> void:
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits.disabled = true
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits/Control.visible = true
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Credits/Control.grab_focus()

func _on_music_volume_focus_entered() -> void:
	$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume/RichTextLabel2".modulate = Color(0.2,0.2,0.4)


func _on_music_volume_focus_exited() -> void:
	$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume/RichTextLabel2".modulate = Color(1.0,1.0,1.0)


func _on_sfx_volume_focus_entered() -> void:
	$"Settings/PanelContainer/MarginContainer/VBoxContainer/SFX Volume/RichTextLabel2".modulate = Color(0.2,0.2,0.4)


func _on_sfx_volume_focus_exited() -> void:
	$"Settings/PanelContainer/MarginContainer/VBoxContainer/SFX Volume/RichTextLabel2".modulate = Color(1,1,1)


func _on_gamemode_toggle_focus_entered() -> void:
	$Gamemode/GamemodeToggle.modulate = Color(1.2,1.2,1.2)

func _on_gamemode_toggle_focus_exited() -> void:
	$Gamemode/GamemodeToggle.modulate = Color(1,1,1)


func _on_gamemode_toggle_2_focus_entered() -> void:
	$Gamemode/GamemodeToggle2.modulate = Color(1.2,1.2,1.2)

func _on_gamemode_toggle_2_focus_exited() -> void:
	$Gamemode/GamemodeToggle2.modulate = Color(1,1,1)


func _on_gamemode_toggle_3_focus_entered() -> void:
	$Gamemode/GamemodeToggle3.modulate = Color(1.2,1.2,1.2)

func _on_gamemode_toggle_3_focus_exited() -> void:
	$Gamemode/GamemodeToggle3.modulate = Color(1,1,1)


func _on_focuscheck_timeout() -> void:
	areacheck()

func refreshtextsize() -> void:
	$Gamemode/RichTextLabel2.text = "[font_size=33]" + tr("MENU_SELECT_GAMEMODE") + "[br][font_size=17]" + tr("MENU_CLICK_GAMEMODE")
	if TranslationServer.get_locale() == "jp":
		$Buttons/Button.add_theme_font_size_override("font_size", 24)
		$Buttons/Button2.add_theme_font_size_override("font_size", 24)
		$Buttons/Button3.add_theme_font_size_override("font_size", 24)
		$Settings/PanelContainer/MarginContainer/VBoxContainer/CheckButton.add_theme_font_size_override("font_size", 13) #holy shit i have to do this manually fuck my life i hate this font
		$Settings/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel.add_theme_font_size_override("normal_font_size", 13)
		$Settings/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel2.add_theme_font_size_override("normal_font_size", 13)
		$Settings/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel.add_theme_font_size_override("normal_font_size", 13)
		$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume/RichTextLabel2".add_theme_font_size_override("normal_font_size", 15)
		$"Settings/PanelContainer/MarginContainer/VBoxContainer/SFX Volume/RichTextLabel2".add_theme_font_size_override("normal_font_size", 15)
		$"Settings/PanelContainer/MarginContainer/VBoxContainer/Change Language".add_theme_font_size_override("font_size", 13)
	else:
		$Buttons/Button.add_theme_font_size_override("font_size", 33)
		$Buttons/Button2.add_theme_font_size_override("font_size", 33)
		$Buttons/Button3.add_theme_font_size_override("font_size", 33)
		$Settings/PanelContainer/MarginContainer/VBoxContainer/CheckButton.add_theme_font_size_override("font_size", 17)
		$Settings/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel.add_theme_font_size_override("normal_font_size", 17)
		$Settings/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel2.add_theme_font_size_override("normal_font_size", 17)
		$Settings/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel.add_theme_font_size_override("normal_font_size", 17)
		$"Settings/PanelContainer/MarginContainer/VBoxContainer/Music Volume/RichTextLabel2".add_theme_font_size_override("normal_font_size", 17)
		$"Settings/PanelContainer/MarginContainer/VBoxContainer/SFX Volume/RichTextLabel2".add_theme_font_size_override("normal_font", 17)
		$"Settings/PanelContainer/MarginContainer/VBoxContainer/Change Language".add_theme_font_size_override("font_size", 17)

func _on_change_language_pressed() -> void:
	if TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("jp")
	else:
		TranslationServer.set_locale("en")
	refreshtextsize()
