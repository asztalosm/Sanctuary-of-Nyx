extends CanvasLayer
var openedinventory = false

func _ready() -> void:
	$Ability/Cooldown.wait_time = get_parent().abilitywaittime

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
		if openedinventory == false:
			get_tree().paused = true
			$Inventory.visible = true
			openedinventory = true
		else:
			get_tree().paused = false
			$Inventory.visible = false
			openedinventory = false
