extends CharacterBody2D
#so in this script there will be a helmet boolean, that will be used in animations. thats how it will calculate which sprites to use
#some ideas on how this should work - physical attacks will break the helmet, magical ones will bypass it
#helmet blocks 1 attack, enemy can also use it's shield to stun the player
@export var helmet = true
@export var maxhealth : float = 10
@export var health : float = maxhealth
@export var speed = 50
@export var damage :float = 3
@export var attackcooldown = 1.2
@export var cantakedamage = true
@export var target = self
@export var stunned = false
var onattackcooldown = false
var dir := Vector2.ZERO
var dead = false
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")

func stun() -> void:
	stunned = true
	await get_tree().create_timer(3.0).timeout
	stunned = false

func death() -> void:
	dead = true
	player.globalcharacterstats.Xp += 30 + player.arcadeStats.get("more XP per kill")
	player.addpoints(20)
	$GPUParticles2D.restart()
	for nodes in self.get_children():
		if nodes != $GPUParticles2D:
			nodes.queue_free()

func _ready() -> void:
	print("advanced skeleton aa")


func _on_stun_area_body_entered(body: Node2D) -> void:
	body.stun()
	helmet = false

func _process(_delta: float) -> void:
	$AnimatedSprite2D.animation = str("default", helmet) #just a proof of concept
