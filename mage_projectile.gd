extends CharacterBody2D
@export var moving = false
@export var target = null #adding this as an export incase i make a weapon that homes to the enemies
@export var speed = 220 # i probably 
#mage projectile
func _on_timer_timeout() -> void:
	get_parent().attacked = false
	moving = false
	global_position = get_parent().global_position
	$MageHitcheck/AnimatedSprite2D.animation = "default"

func start() -> void:
	if !moving:
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
