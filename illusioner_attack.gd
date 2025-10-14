extends CharacterBody2D
var dir = Vector2.ZERO
var SPEED = 110

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	queue_free()


func _physics_process(_delta: float) -> void:
	dir = global_position.direction_to(get_parent().player.global_position)
	velocity = dir * SPEED
	move_and_slide()

func _on_homing_projectile_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.hit(get_parent().damage, get_parent().dodgeable, get_parent().truedamage)
		queue_free()
