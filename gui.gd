extends CanvasLayer
var clickedskill = false

func refreshstats() -> void:
	$Skills/Info.text = "You currently have " + str(get_parent().globalcharacterstats.SkillPoints) + " Skill Points."
	$Skills/ItemList.set_item_text(0, "Physical Attack ("+ str(get_parent().skills.PhysAtk) +")")
	$Skills/ItemList.set_item_text(1, "Defense ("+ str(get_parent().skills.Defense) +")")
	$Skills/ItemList.set_item_text(2, "Speed and Dodge ("+ str(get_parent().skills.Dodge) +")")
	$Skills/ItemList.set_item_text(3, "Health ("+ str(get_parent().skills.Health) +")")
	$Skills/ItemList.set_item_tooltip(0, "Multiplies your Physical damage by " + (str(float(get_parent().skills.PhysAtk + 10) / 10)))
	$Skills/ItemList.set_item_tooltip(1, "Decreases incoming damage by "+ str(float(get_parent().defense)))
	$Skills/ItemList.set_item_tooltip(2, "Increases movement speed by 2 ("+ str(float(get_parent().dodgechance)) + ") and movement speed by 2 (" + str(float(get_parent().speed)) + ")")
	$Skills/ItemList.set_item_tooltip(3, "Increase your max health and health by 2 ("+str(float(get_parent().maxhealth))+")")
func showinventory() -> void:
	get_tree().paused = true
	$Inventory.visible = true
	$Skills.visible = false
	$Inventory/VSplitContainer/Control/TextureRect/Charactericon.texture = get_parent().currentcharacter.Icon
	$Inventory/VSplitContainer/Control2/MarginContainer/GridContainer/HeadBg.used_text = "[color=444444] Slot for helmet [/color][p] [color=22BB22]+x Defense[/color] [p] +x Health [p] -x Movement speed"
	
	
func _ready() -> void:
	get_parent().globalcharacterstats.SkillPoints = 10
	$Ability/Cooldown.wait_time = get_parent().abilitywaittime
	$Skills/ItemList.allow_reselect = false
	$Skills/ItemList.allow_rmb_select = false
	refreshstats()
	$Inventory/VSplitContainer/Control/TextureRect/Charactericon.texture = get_parent().currentcharacter.Icon

func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _process(_delta: float) -> void:
	$Health/HealthBar.max_value = get_parent().maxhealth
	$Health/HealthBar.value = get_parent().health
	$Experience/TextureProgressBar.max_value = get_parent().globalcharacterstats.XptoNextLevel
	$Experience/TextureProgressBar.value = get_parent().globalcharacterstats.Xp
	if get_parent().abilityinuse == true:
		$Ability/TextureProgressBar.max_value = get_parent().abilityduration
		$Ability/TextureProgressBar.value = $Ability/AbilityDuration.time_left
	else:
		$Ability/TextureProgressBar.max_value = get_parent().abilitywaittime
		$Ability/TextureProgressBar.value = get_parent().abilitywaittime - $Ability/Cooldown.time_left
	if Input.is_action_just_pressed("Inventory") and get_parent().health > 0:
		if $Inventory.visible == false:
			showinventory()
		else:
			get_tree().paused = false
			$Inventory.visible = false
	if Input.is_action_just_pressed("Skills") and get_parent().health > 0:
		if $Skills.visible == false:
			$Skills/ItemList.grab_focus()
			refreshstats()
			$Skills.visible = true
			get_tree().paused = true
			$Inventory.visible = false
		else:
			get_tree().paused = false
			$Skills.visible = false
		


func _on_item_list_item_selected(_index: int) -> void:
	refreshstats()


func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	clickedskill = true
	if get_parent().globalcharacterstats.SkillPoints > 0:
		get_parent().globalcharacterstats.SkillPoints -= 1
		$Skills/Info.text = "You currently have " + str(get_parent().globalcharacterstats.SkillPoints) + " Skill Points."
		if index == 0:
			get_parent().skills.PhysAtk += 1
			$Skills/ItemList.set_item_text(0, "Physical Attack ("+ str(get_parent().skills.PhysAtk) +")")
		elif index == 1:
			get_parent().skills.Defense += 1
			$Skills/ItemList.set_item_text(1, "Defense ("+ str(get_parent().skills.Defense) +")")
			get_parent().defense = get_parent().skills.Defense /10 * 2
		elif index == 2:
			get_parent().skills.Dodge += 1
			$Skills/ItemList.set_item_text(2, "Speed and Dodge ("+ str(get_parent().skills.Dodge) +")")
			get_parent().dodgechance += 1
			get_parent().speed += 2
		elif index == 3:
			get_parent().skills.Health += 1
			$Skills/ItemList.set_item_text(2, "Health ("+ str(get_parent().skills.Health) +")")
			get_parent().maxhealth += 2
			get_parent().health += 2
	$Skills/ItemList.deselect_all()
	refreshstats()
	await get_tree().create_timer(1).timeout
	clickedskill = false


func _on_item_list_item_activated(index: int) -> void:
	if get_parent().globalcharacterstats.SkillPoints > 0 and !clickedskill:
		get_parent().globalcharacterstats.SkillPoints -= 1
		$Skills/Info.text = "You currently have " + str(get_parent().globalcharacterstats.SkillPoints) + " Skill Points."
		if index == 0:
			get_parent().skills.PhysAtk += 1
			$Skills/ItemList.set_item_text(0, "Physical Attack ("+ str(get_parent().skills.PhysAtk) +")")
		elif index == 1:
			get_parent().skills.Defense += 1
			$Skills/ItemList.set_item_text(1, "Defense ("+ str(get_parent().skills.Defense) +")")
			get_parent().defense = get_parent().skills.Defense /10 * 2
		elif index == 2:
			get_parent().skills.Dodge += 1
			$Skills/ItemList.set_item_text(2, "Speed and Dodge ("+ str(get_parent().skills.Dodge) +")")
			get_parent().dodgechance += 1
			get_parent().speed += 2
	refreshstats()
