extends CharacterBody2D

@export var maxhealth : float = 10
@export var health : float = maxhealth
@export var speed = 50
@export var damage :float = 3
@export var attackcooldown = 1.2
@export var cantakedamage = true
@export var target = self
@export var chargetime = 2.0
@export var stunned = false
var onattackcooldown = false
var dir := Vector2.ZERO
var dead = false
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")
func _ready() -> void:
	$HealthBar.max_value = maxhealth
	$AttackCooldown.wait_time = attackcooldown

func hit(selfdamage) -> void:
	health -= selfdamage
	$AnimationPlayer.play("hit")

func stun() -> void:
	stunned = true
	var stuntime = 3.0
	var stunscene = load("res://stun.tscn").instantiate()
	stunscene.global_position = global_position + Vector2(0,-12)
	stunscene.sprite_frames.set_animation_speed("default", 7 / stuntime)
	stunscene.play("default")
	self.add_child(stunscene)
	await get_tree().create_timer(stuntime).timeout
	stunned = false

func death() -> void:
	dead = true
	player.globalcharacterstats.Xp += 30 + player.arcadeStats.get("more XP per kill")
	player.addpoints(20)
	if get_parent().get_parent().name == "Dungeon":
		var gpuparticle = load("res://coin_particles.tscn").instantiate()
		get_parent().add_child(gpuparticle)
		var coins = randi_range(1,8)
		gpuparticle.global_position = global_position
		gpuparticle.amount = coins
		get_parent().get_parent().coins += coins
	$GPUParticles2D.restart()
	for nodes in self.get_children():
		if nodes != $GPUParticles2D:
			nodes.queue_free()

func attack() -> void:
	if !onattackcooldown and !dead:
		onattackcooldown = true
		await get_tree().create_timer(chargetime).timeout #this will be changed to a normal timer but its 1am
		var arrow = preload("res://arrow.tscn").instantiate()
		await get_tree().create_timer(0.01).timeout
		if get_node_or_null("AttackCooldown") != null:
			add_child(arrow)
			$AttackCooldown.start()
			arrow.global_position = self.global_position
			arrow.dir = arrow.global_position.direction_to(target.global_position)

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0 and !dead:
		death()
	elif !dead:
		if health != maxhealth:
			$HealthBar.visible = true
			$HealthBar.value = health
		if !stunned:
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
	$Detection.scale = Vector2(3,3)


func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false


func _on_detection_body_exited(_body: Node2D) -> void:
	target = self


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
