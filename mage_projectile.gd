extends CharacterBody2D
@export var moving = false
@export var target = null #adding this as an export incase i make a weapon that homes to the enemies
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
		
		move_and_slide()
