extends CharacterBody2D
@export var maxhealth : float = 10
@export var health : float = maxhealth
@export var speed = 60
@export var damage :float = 3
@export var attackcooldown = 2.0
@export var cantakedamage = true
@export var target = self
var onattackcooldown = false
var dir := Vector2.ZERO
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")
@export var dead = false
var characterinrange = false
@export var stunned = false


func _ready() -> void:
	$HealthBar.max_value = maxhealth

func death() -> void:
	dead = true
	player.globalcharacterstats.Xp += 20 + player.arcadeStats.get("more XP per kill")
	player.addpoints(10)
	$GPUParticles2D.restart()
	for nodes in self.get_children():
		if nodes != $GPUParticles2D:
			nodes.queue_free()

func throwpotion() -> void:
	var potion = preload("res://potionprojectile.tscn").instantiate()
	potion.targetposition = target.global_position
	await get_tree().create_timer(0.01).timeout
	get_parent().add_child(potion)
	potion.targetposition = target.global_position
	potion.global_position = global_position

func attack() -> void:
	if !onattackcooldown and !stunned:
		$AttackCooldown.wait_time = attackcooldown
		onattackcooldown = true
		$AttackCooldown.start()
		throwpotion()

func stun() -> void:
	stunned = true
	await get_tree().create_timer(3.0).timeout
	stunned = false

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0 and !dead:
		death()
	elif !dead:
		if characterinrange and !onattackcooldown:
			attack()
		if health != maxhealth:
			$HealthBar.visible = true
			$HealthBar.value = health
		if !stunned:
			if target != self:
				if global_position.distance_to(target.global_position) < 70:
					$NavigationAgent2D.target_position = (global_position - target.global_position) * Vector2(100, 100)
					dir = $NavigationAgent2D.get_next_path_position() - global_position
				else:
					$NavigationAgent2D.target_position = target.global_position
					dir = $NavigationAgent2D.get_next_path_position() - global_position + Vector2(randf_range(-15, 15), randf_range(-15, 15))
				if global_position.distance_to(target.global_position) > 180:
					target = self
				else:
					if $NavigationAgent2D.is_target_reached():
						attack()
					if dir.length_squared() > 1.0:
							dir = dir.normalized()
							velocity = dir * speed
	move_and_slide()




func _on_detection_body_entered(body: Node2D) -> void:
		target = body
		characterinrange = true


func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false


func _on_gpu_particles_2d_finished() -> void:
	queue_free()


func _on_detection_body_exited(_body: Node2D) -> void:
	characterinrange = false
