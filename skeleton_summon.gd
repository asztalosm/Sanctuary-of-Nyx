extends CharacterBody2D
@export var maxhealth : float = 5
@export var health : float = maxhealth
@export var speed = 95
@export var damage :float = 1.0
@export var attackcooldown = 0.8
@export var cantakedamage = true
@export var target = self
var onattackcooldown = false
var canattack = true
var dir := Vector2.ZERO
func _ready() -> void:
	$HealthBar.max_value = maxhealth

func death() -> void:
	#death animation
	queue_free()
func attack() -> void:
	if !onattackcooldown and target.cantakedamage:
		$AttackCooldown.wait_time = attackcooldown
		onattackcooldown = true
		$AttackCooldown.start()
		target.hit(damage)


func _physics_process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0:
		death()
	elif health != maxhealth:
		$HealthBar.visible = true
		$HealthBar.value = health
	if target != self:
		if global_position.distance_to(target.global_position) > 220:
			target = self
		else:
			if $NavigationAgent2D.is_target_reached():
				attack()
			$NavigationAgent2D.target_position = target.global_position
			dir = $NavigationAgent2D.get_next_path_position() - global_position
			if dir.length_squared() > 1.0:
					dir = dir.normalized()
					velocity = dir * speed
			if velocity != Vector2(0,0):
				$AnimatedSprite2D.play("walk")
	move_and_slide()




func _on_detection_body_entered(body: Node2D) -> void:
	target = body
	$NavigationAgent2D.target_desired_distance = $Detection/AttackZone/CollisionShape2D.shape.radius


func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false
