extends CharacterBody2D
@export var health = INF
func hit(selfdamage):
	$AnimationPlayer.play("hit")
	var damageNumber = load("res://damage_number.tscn").instantiate()
	damageNumber.get_node("RichTextLabel").text = "- " + str(int(selfdamage))
	damageNumber.global_position = global_position + Vector2(randi_range(-30, 30), randi_range(-30, 30))
	add_child(damageNumber)

func stun():
	return
