extends CanvasLayer

func _ready() -> void:
	visible = true

func _on_button_pressed() -> void:
	queue_free()
