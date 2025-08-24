extends CanvasLayer

func _ready() -> void:
	$Ability/Cooldown.wait_time = get_parent().abilitywaittime

func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _process(_delta: float) -> void:
	$Health/HealthBar.max_value = get_parent().maxhealth
	$Health/HealthBar.value = get_parent().health
	if get_parent().abilityinuse == true:
		$Ability/TextureProgressBar.max_value = get_parent().abilityduration
		$Ability/TextureProgressBar.value = $Ability/AbilityDuration.time_left
	else:
		$Ability/TextureProgressBar.max_value = get_parent().abilitywaittime
		$Ability/TextureProgressBar.value = get_parent().abilitywaittime - $Ability/Cooldown.time_left
