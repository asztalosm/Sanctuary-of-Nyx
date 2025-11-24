extends CharacterBody2D

@export var maxhealth : float = 10
@export var health : float = maxhealth
@onready var player = get_parent().get_parent().get_parent().get_node("Character").get_node("Player")

func hit(selfdamage) -> void:
	health -= selfdamage
	$AnimationPlayer.play("hit")
	if health <= 0:
		death()


func death() -> void:
	#player.globalcharacterstats.Xp += 1000 + player.arcadeStats.get("more XP per kill")
	match randi_range(1,3):
		1:
			player.health = player.maxhealth
		2:
			get_parent().get_parent().get_parent().coins += 50
		3:
			player.globalcharacterstats.SkillPoints += 1
	queue_free()
