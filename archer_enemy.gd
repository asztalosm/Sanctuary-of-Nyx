extends CharacterBody2D

@export var maxhealth : float = 10
@export var health : float = maxhealth
@export var speed = 50
@export var damage :float = 3
@export var attackcooldown = 1.2
@export var cantakedamage = true
@export var target = self
@export var chargetime = 2.0
var onattackcooldown = false
var dir := Vector2.ZERO

func _ready() -> void:
	$HealthBar.max_value = maxhealth
	$AttackCooldown.wait_time = attackcooldown

func death() -> void:
	queue_free()

func attack() -> void:
	if !onattackcooldown:
		onattackcooldown = true
		await get_tree().create_timer(chargetime).timeout #this will be changed to a normal timer but its 1am
		var arrow = preload("res://arrow.tscn").instantiate()
		await get_tree().create_timer(0.01).timeout
		add_child(arrow)
		$AttackCooldown.start()
		arrow.global_position = self.global_position
		arrow.dir = arrow.global_position.direction_to(target.global_position)

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0:
		death()
	elif health != maxhealth:
		$HealthBar.visible = true
		$HealthBar.value = health
	if target != self:
		if global_position.distance_to(target.global_position) < 100:
			$NavigationAgent2D.target_position = (global_position - target.global_position) * Vector2(100, 100)
			dir = $NavigationAgent2D.get_next_path_position() - global_position
			if dir.length_squared() > 1.0:
					dir = dir.normalized()
		else: 
			attack()
			dir = Vector2(0,0)
			velocity = Vector2(0,0)
	velocity = dir * speed
	move_and_slide()

func _on_detection_body_entered(body: Node2D) -> void:
	target = body


func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false


func _on_detection_body_exited(_body: Node2D) -> void:
	target = self
