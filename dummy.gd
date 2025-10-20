extends CharacterBody2D
#most barebones script ever
@export var maxhealth : float = 10
@export var health : float = maxhealth
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")

func hit(selfdamage) -> void:
	health -= selfdamage
	$AnimationPlayer.play("hit")
	if health <= 0:
		death()

func _ready() -> void:
	$HealthBar.max_value = maxhealth

func death() -> void:
	player.globalcharacterstats.Xp += 1000 + player.arcadeStats.get("more XP per kill")
	get_parent().get_parent().get_node("Collisions").get_node("StaticBody2D").queue_free()
	get_parent().get_parent().get_node("Overlay").counter += 1
	get_parent().get_parent().get_node("Overlay").canProgress()
	queue_free()

func _physics_process(_delta: float) -> void:
	$HealthBar.value = health
