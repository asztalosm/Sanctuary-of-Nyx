extends CharacterBody2D
@export var moving = false
@export var target = null #adding this as an export incase i make a weapon that homes to the enemies
@export var speed = 220
#mage projectile
func _on_timer_timeout() -> void:
	get_parent().attacked = false
	moving = false
	global_position = get_parent().global_position
	$MageHitcheck/AnimatedSprite2D.animation = "default"

func start() -> void:
	if !moving:
		get_parent().hitenemies.clear()
		moving = true
		$MageHitcheck/Timer.start()
		$MageHitcheck/AnimatedSprite2D.play("playing")


func _physics_process(delta: float) -> void:
	if moving:
		target = get_global_mouse_position()
		look_at(target)
		if global_position.distance_to(target) > 2.0:
			velocity = transform.x * speed
		else:
			velocity = Vector2.ZERO
		move_and_slide()


func _on_mage_hitcheck_area_entered(area: Area2D) -> void:
	moving = false
	get_parent().hitenemies.append(area.get_parent())
	get_parent().applydamage()
	global_position = get_parent().global_position
	$MageHitcheck/AnimatedSprite2D.animation = "default"
