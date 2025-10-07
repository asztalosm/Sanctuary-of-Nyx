extends CanvasLayer

func _ready() -> void:
	visible = true
	$Button.grab_focus()

func _on_button_pressed() -> void:
	get_parent().get_node("Intermission").get_node("Dice").get_node("EnemyStats").grab_focus()
	queue_free()
