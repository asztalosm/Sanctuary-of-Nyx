extends Area2D
var inarea = false
@export var character = null
@export var damage = 5
func _process(_delta: float) -> void:
	if character != null and character.cantakedamage and inarea:
		character.hit(damage)

func _on_area_entered(area: Area2D) -> void:
	character = area.get_parent()
	inarea = true


func _on_area_exited(area: Area2D) -> void:
	character = null
	inarea = false
