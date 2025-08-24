extends CharacterBody2D
@export var maxhealth = 10
@export var health = maxhealth
@export var speed = 80
@export var damage = 5
@export var cantakedamage = true

func _ready() -> void:
	$HealthBar.max_value = maxhealth

func death() -> void:
	queue_free()

func _physics_process(_delta: float) -> void:
	if health < 0:
		death()
	elif health != maxhealth:
		$HealthBar.visible = true
		$HealthBar.value = health
		
