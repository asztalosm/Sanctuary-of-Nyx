extends CanvasLayer
var clickedskill = false
@export var otherbutton = true

func refreshtextsize() -> void:
	if TranslationServer.get_locale() == "jp":
		$Skills/Title.add_theme_font_size_override("normal_font_size", 24)
		$Skills/Info.add_theme_font_size_override("normal_font_size", 24)
		for children in $Skills/GridContainer.get_children():
			children.add_theme_font_size_override("font_size", 17)

func refreshstats() -> void:
	$Skills/Title.text = tr("SKILLS")
	$Skills/Info.text = tr("SKILLINFO_1") + str(get_parent().globalcharacterstats.SkillPoints) + tr("SKILLINFO_2")
	$Skills/GridContainer/PhysAtk.text = tr("SKILL_PHYSATK_1") +str(get_parent().skills.PhysAtk) + "]"
	$Skills/GridContainer/PhysAtk.used_text = tr("SKILL_PHYSATK_USED_1") + "[color=#22BB22]" + (str(float(get_parent().skills.PhysAtk + 10) / 10)) + "[/color]" + tr("SKILL_PHYSATK_USED_2")
	$Skills/GridContainer/MagicAtk.text = tr("SKILL_MAGICATK_1") +str(get_parent().skills.MagicAtk) + "]"
	$Skills/GridContainer/MagicAtk.used_text = tr("SKILL_MAGICATK_USED_1")+"[color=#22BB22]" + (str(float(get_parent().skills.MagicAtk + 10) / 10)) + "[/color]" + tr("SKILL_MAGICATK_USED_2")
	$Skills/GridContainer/Defense.text = tr("SKILL_DEFENSE_1") + str(get_parent().skills.Defense) + "]"
	$Skills/GridContainer/Defense.used_text = tr("SKILL_DEFENSE_USED_1")+"[color=#22BB22]" + (str(float(get_parent().skills.Defense) * 0.2) + "[/color]" + tr("SKILL_DEFENSE_USED_2"))
	$Skills/GridContainer/Dodge.text = tr("SKILL_DODGE_1") + str(get_parent().skills.Dodge) + "]"
	$Skills/GridContainer/Dodge.used_text = tr("SKILL_DODGE_USED_1") + "[color=#22BB22]2[/color][color=#00FF00] [" + str(get_parent().speed) + "][/color][p]" + tr("SKILL_DODGE_USED_1") +"[color=#22BB22]1[/color][color=#00FF00] [" + str(get_parent().dodgechance) + "][/color]" + tr("SKILL_DODGE_USED_3")
	$Skills/GridContainer/Health.text = tr("SKILL_HEALTH_1") + str(get_parent().skills.Health) + "]"
	$Skills/GridContainer/Health.used_text = tr("SKILL_HEALTH_USED_1") +"[color=#22BB22]" + (str(float(get_parent().skills.Health)*2)) + "[/color][p]" + tr("SKILL_HEALTH_USED_2") + "[color=#22BB22]4hp[/color]" + tr("SKILL_HEALTH_USED_3") #this might be changed to like a heal potion but i feel like this is going to be SO many buttons
	$Skills/GridContainer/AtkSpeed.text = tr("SKILL_ATKSPEED_1") + str(get_parent().skills.AtkSpeed) + "]"
	$Skills/GridContainer/AtkSpeed.used_text = tr("SKILL_ATKSPEED_USED_1") +"[color=#22BB22]"+ str(float(1 + (get_parent().skills.AtkSpeed)*0.025)) + "x[/color][p]" + tr("SKILL_ATKSPEED_USED_2") + "[color=#22BB22]"+ str(float(get_parent().skills.AtkSpeed)*0.1) + "s[/color]" + tr("SKILL_ATKSPEED_USED_3")
	refreshtextsize()
func showinventory() -> void:
	get_tree().paused = true
	$Inventory.visible = true
	$Skills.visible = false
	$Inventory/VSplitContainer/Control/TextureRect/Charactericon.texture = get_parent().currentcharacter.Icon
	$Inventory/VSplitContainer/Control2/MarginContainer/GridContainer/HeadBg.used_text = "[color=444444] Slot for helmet [/color][p] [color=22BB22]+x Defense[/color] [p] +x Health [p] -x Movement speed"
func showskills() -> void:
	if !$Pause.visible:
		$Skills.visible = true
		get_tree().paused = true
		$Inventory.visible = false
		$Skills/GridContainer/PhysAtk.grab_focus()
func _ready() -> void:
	refreshtextsize()
	$Pause/Settings2/PanelContainer/MarginContainer/VBoxContainer/CheckButton.button_pressed = MenuMusic.damagenumber
	$"Pause/Settings2/PanelContainer/MarginContainer/VBoxContainer/Music Volume".value = MenuMusic.musicvolume
	$"Pause/Settings2/PanelContainer/MarginContainer/VBoxContainer/SFX Volume".value = MenuMusic.sfxvolume
	$Ability/Cooldown.wait_time = get_parent().currentcharacter.AbilityCooldown
	refreshstats()
	$Inventory/VSplitContainer/Control/TextureRect/Charactericon.texture = get_parent().currentcharacter.Icon

func _process(_delta: float) -> void:
	$Charactericon.texture = get_parent().currentcharacter.Icon
	$Health/HealthBar.max_value = get_parent().maxhealth
	$Health/HealthBar.value = get_parent().health
	$Experience/TextureProgressBar.max_value = get_parent().globalcharacterstats.XptoNextLevel
	$Experience/RichTextLabel.text = str(get_parent().globalcharacterstats.Xp) + "/" + str(get_parent().globalcharacterstats.XptoNextLevel) + " xp"
	$Experience/TextureProgressBar.value = get_parent().globalcharacterstats.Xp
	if get_parent().abilityinuse == true:
		$Ability/TextureProgressBar.max_value = get_parent().currentcharacter.AbilityDuration
		$Ability/TextureProgressBar.value = $Ability/AbilityDuration.time_left
	else:
		$Ability/TextureProgressBar.max_value = get_parent().currentcharacter.AbilityCooldown
		$Ability/TextureProgressBar.value = get_parent().currentcharacter.AbilityCooldown - $Ability/Cooldown.time_left
	#opens menus if player isn't dead
	if Input.is_action_just_pressed("pause") and get_parent().health > 0 and get_parent().pausable:
		if $Pause.visible == true:
			get_tree().paused = false
			$Pause.visible = false
		else:
			if !$Skills.visible:
				$Pause/Resume.grab_focus()
				get_tree().paused = true
				$Pause.visible = true
	if Input.is_action_just_pressed("Inventory") and get_parent().health > 0 and false == true: #made this not work because inventory system isnt implemented yet and wont be for a long fucking time
		if $Inventory.visible == false:
			showinventory()
		else:
			get_tree().paused = false
			$Inventory.visible = false
	#if Input.is_action_just_pressed("Skills") and get_parent().health > 0:
	#	if $Skills.visible == false:
	#		refreshstats()
	#		showskills()
	#	else:
	#		get_tree().paused = false
	#		$Skills.visible = false
	if Input.is_action_just_pressed("multichange") and get_parent().health > 0:
		get_parent().canattack = false
		if $Skills.visible == false:
			$Carousel.visible = true
			otherbutton = false
		else:
			get_parent().canattack = true
			$Skills.visible = false
			get_tree().paused = false
	if $Carousel.visible:
		if Input.is_action_just_pressed("lookup"):
			otherbutton = true
			get_tree().paused = false
			get_parent().switchcharacter(get_parent().Characters[0])
			$Carousel.visible = false
			await get_tree().create_timer(0.5).timeout
			get_parent().canattack = true
		elif Input.is_action_just_pressed("lookright"):
			otherbutton = true
			get_tree().paused = false
			get_parent().switchcharacter(get_parent().Characters[2])
			$Carousel.visible = false
			await get_tree().create_timer(0.5).timeout
			get_parent().canattack = true
		elif Input.is_action_just_pressed("lookleft"):
			otherbutton = true
			get_tree().paused = false
			get_parent().switchcharacter(get_parent().Characters[1])
			$Carousel.visible = false
			await get_tree().create_timer(0.5).timeout
			get_parent().canattack = true
		elif Input.is_action_just_pressed("lookdown"):
			otherbutton = true
			get_tree().paused = false
			get_parent().switchcharacter(get_parent().Characters[3])
			$Carousel.visible = false
			await get_tree().create_timer(0.5).timeout
			get_parent().canattack = true
	if Input.is_action_just_released("multichange") and get_parent().health > 0 and $Carousel.visible and !otherbutton:
		$Carousel.visible = false
		refreshstats()
		showskills()


#Skill GUI buttons
func _on_phys_atk_pressed() -> void:
	if get_parent().globalcharacterstats.SkillPoints > 0 and !clickedskill:
		get_parent().globalcharacterstats.SkillPoints -= 1
		get_parent().skills.PhysAtk += 1
		$Skills/GridContainer/PhysAtk.text = "Physical Attack [" + str(get_parent().skills.PhysAtk) + "]"
	else:
		$Skills/GridContainer/PhysAtk.modulate = Color8(192,32,32)
		await get_tree().create_timer(0.5).timeout
		$Skills/GridContainer/PhysAtk.modulate = Color8(255,255,255)
	refreshstats()

func _on_magic_atk_pressed() -> void:
	if get_parent().globalcharacterstats.SkillPoints > 0 and !clickedskill:
		get_parent().globalcharacterstats.SkillPoints -= 1
		get_parent().skills.MagicAtk += 1
		$Skills/GridContainer/MagicAtk.text = "Magic Attack [" + str(get_parent().skills.MagicAtk) + "]"
	else:
		$Skills/GridContainer/MagicAtk.modulate = Color8(192,32,32)
		await get_tree().create_timer(0.5).timeout
		$Skills/GridContainer/MagicAtk.modulate = Color8(255,255,255)
	refreshstats()


func _on_defense_pressed() -> void:
	if get_parent().globalcharacterstats.SkillPoints > 0 and !clickedskill:
		get_parent().globalcharacterstats.SkillPoints -= 1
		get_parent().skills.Defense += 1
	else:
		$Skills/GridContainer/Defense.modulate = Color8(192,32,32)
		await get_tree().create_timer(0.5).timeout
		$Skills/GridContainer/Defense.modulate = Color8(255,255,255)
	refreshstats()

func _on_dodge_pressed() -> void:
	if get_parent().globalcharacterstats.SkillPoints > 0 and !clickedskill:
		get_parent().globalcharacterstats.SkillPoints -= 1
		get_parent().skills.Dodge += 1
		get_parent().speed += 2
		get_parent().dodgechance += 1
	else:
		$Skills/GridContainer/Dodge.modulate = Color8(192,32,32)
		await get_tree().create_timer(0.5).timeout
		$Skills/GridContainer/Dodge.modulate = Color8(255,255,255)
	refreshstats()


func _on_health_pressed() -> void:
	if get_parent().globalcharacterstats.SkillPoints > 0 and !clickedskill:
		get_parent().globalcharacterstats.SkillPoints -= 1
		get_parent().skills.Health += 1
		get_parent().maxhealth += 2
		if get_parent().health + 4 > get_parent().maxhealth:
			return
		else:
			get_parent().health += 4
		$Skills/GridContainer/Health.text = "Health [" + str(get_parent().skills.Health) + "]"
	else:
		$Skills/GridContainer/Health.modulate = Color8(192,32,32)
		await get_tree().create_timer(0.5).timeout
		$Skills/GridContainer/Health.modulate = Color8(255,255,255)
	refreshstats()


func _on_atk_speed_pressed() -> void:
	if get_parent().globalcharacterstats.SkillPoints > 0 and !clickedskill and get_parent().skills.AtkSpeed < 10:
		get_parent().globalcharacterstats.SkillPoints -= 1
		get_parent().skills.AtkSpeed += 1
		$Skills/GridContainer/AtkSpeed.text = "Magic Attack [" + str(get_parent().skills.AtkSpeed) + "]"
	else:
		$Skills/GridContainer/AtkSpeed.modulate = Color8(192,32,32)
		await get_tree().create_timer(0.5).timeout
		$Skills/GridContainer/AtkSpeed.modulate = Color8(255,255,255)
	refreshstats()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()



func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_resume_pressed() -> void:
	get_tree().paused = false
	$Pause.visible = false


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_settings_pressed() -> void:
	var settingsTween = get_tree().create_tween()
	settingsTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	if $Pause/Settings2.visible:
		settingsTween.tween_property($Pause/Settings2, "scale:y", 0.0, 0.3)
		await settingsTween.finished
		$Pause/Settings2.visible = false
	else:
		$Pause/Settings2.visible = true
		settingsTween.tween_property($Pause/Settings2, "scale:y", 1.0, 0.3)
		await settingsTween.finished
	$MenuButton.stream = load("res://resources/menubutton.wav")
	$MenuButton.play()


func _on_music_volume_value_changed(value: float) -> void:
	MenuMusic.musicvolume = value


func _on_sfx_volume_value_changed(value: float) -> void:
	MenuMusic.sfxvolume = value


func _on_check_button_pressed() -> void:
	if !MenuMusic.damagenumber:
		MenuMusic.damagenumber = true
	else:
		MenuMusic.damagenumber = false
