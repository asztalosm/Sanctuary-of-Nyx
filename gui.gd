extends CanvasLayer
var clickedskill = false

func refreshstats() -> void:
	$Skills/Info.text = "You currently have " + str(get_parent().globalcharacterstats.SkillPoints) + " Skill Points."
	$Skills/GridContainer/PhysAtk.text = "Physical Attack [" +str(get_parent().skills.PhysAtk) + "]"
	$Skills/GridContainer/PhysAtk.used_text = "Multiplies your Physical damage by [color=#22BB22]" + (str(float(get_parent().skills.PhysAtk + 10) / 10)) + "[/color]"
	$Skills/GridContainer/MagicAtk.text = "Magic Attack [" +str(get_parent().skills.MagicAtk) + "]"
	$Skills/GridContainer/MagicAtk.used_text = "Multiplies your Magical damage by [color=#22BB22]" + (str(float(get_parent().skills.MagicAtk + 10) / 10)) + "[/color]"
	$Skills/GridContainer/Defense.text = "Defense [" + str(get_parent().skills.Defense) + "]"
	$Skills/GridContainer/Defense.used_text = "Reduces damage taken by [color=#22BB22]" + (str(float(get_parent().skills.Defense) * 0.2))
	$Skills/GridContainer/Dodge.text = "Speed & Dodge [" + str(get_parent().skills.Dodge) + "]"
	$Skills/GridContainer/Dodge.used_text = "Increases movement speed by [color=#22BB22]2[/color][color=#00FF00] [" + str(get_parent().speed) + "][/color][p]and dodge by [color=#22BB22]1[/color][color=#00FF00] [" + str(get_parent().dodgechance) + "][/color]"
	$Skills/GridContainer/Health.text = "Health [" + str(get_parent().skills.Health) + "]"
	$Skills/GridContainer/Health.used_text = "Increases max health by [color=#22BB22]" + (str(float(get_parent().skills.Health)*2)) + "[/color][p]And heals you for [color=#22BB22]4hp[/color] once" #this might be changed to like a heal potion but i feel like this is going to be SO many buttons
	$Skills/GridContainer/AtkSpeed.text = "Attack Speed & Cooldown [" + str(get_parent().skills.AtkSpeed) + "]"
	$Skills/GridContainer/AtkSpeed.used_text = "Speeds up attack by [color=#22BB22]"+ str(float(1 + (get_parent().skills.AtkSpeed)*0.025)) + "x[/color][p]and ability cooldown by [color=#22BB22]"+ str(float(get_parent().skills.AtkSpeed)*0.1) + "s[/color]"
func showinventory() -> void:
	get_tree().paused = true
	$Inventory.visible = true
	$Skills.visible = false
	$Inventory/VSplitContainer/Control/TextureRect/Charactericon.texture = get_parent().currentcharacter.Icon
	$Inventory/VSplitContainer/Control2/MarginContainer/GridContainer/HeadBg.used_text = "[color=444444] Slot for helmet [/color][p] [color=22BB22]+x Defense[/color] [p] +x Health [p] -x Movement speed"
func showskills() -> void:
	$Skills.visible = true
	get_tree().paused = true
	$Inventory.visible = false
	$Skills/GridContainer/PhysAtk.grab_focus()
func _ready() -> void:
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
	if Input.is_action_just_pressed("pause") and get_parent().health > 0:
		if $Pause.visible == true:
			get_tree().paused = false
			$Pause.visible = false
		else:
			get_tree().paused = true
			$Pause.visible = true
	if Input.is_action_just_pressed("Inventory") and get_parent().health > 0 and false == true: #made this not work because inventory system isnt implemented yet and wont be for a long fucking time
		if $Inventory.visible == false:
			showinventory()
		else:
			get_tree().paused = false
			$Inventory.visible = false
	if Input.is_action_just_pressed("Skills") and get_parent().health > 0:
		if $Skills.visible == false:
			refreshstats()
			showskills()
		else:
			get_tree().paused = false
			$Skills.visible = false


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
