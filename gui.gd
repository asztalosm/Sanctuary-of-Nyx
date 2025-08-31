extends CanvasLayer

func refreshstats() -> void:
	$Skills/Info.text = "You currently have " + str(get_parent().globalcharacterstats.SkillPoints) + " Skill Points."
	$Skills/ItemList.set_item_text(0, "Physical Attack ("+ str(get_parent().skills.PhysAtk) +")")
	$Skills/ItemList.set_item_text(1, "Defense ("+ str(get_parent().skills.Defense) +")")
	$Skills/ItemList.set_item_tooltip(0, "Multiplies your Physical damage by " + (str(float(get_parent().skills.PhysAtk + 10) / 10)))
	
func _ready() -> void:
	get_parent().globalcharacterstats.SkillPoints = 10
	$Ability/Cooldown.wait_time = get_parent().abilitywaittime
	print($Skills/ItemList.item_count)
	refreshstats()

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
			get_tree().paused = true
			$Inventory.visible = true
			$Skills.visible = false
		else:
			get_tree().paused = false
			$Inventory.visible = false
	if Input.is_action_just_pressed("Skills") and get_parent().health > 0:
		if $Skills.visible == false:
			refreshstats()
			$Skills.visible = true
			get_tree().paused = true
			$Inventory.visible = false
		else:
			get_tree().paused = false
			$Skills.visible = false
		


func _on_item_list_item_selected(index: int) -> void:
	$Skills/ItemList.deselect(index)
	if get_parent().globalcharacterstats.SkillPoints > 0:
		get_parent().globalcharacterstats.SkillPoints -= 1
		$Skills/Info.text = "You currently have " + str(get_parent().globalcharacterstats.SkillPoints) + " Skill Points."
		if index == 0:
			get_parent().skills.PhysAtk += 1
			$Skills/ItemList.set_item_text(0, "Physical Attack ("+ str(get_parent().skills.PhysAtk) +")")
		elif index == 1:
			get_parent().skills.Defense += 1
			$Skills/ItemList.set_item_text(1, "Defense ("+ str(get_parent().skills.Defense) +")")
	
	refreshstats()
