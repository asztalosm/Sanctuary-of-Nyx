extends CharacterBody2D
#so in this script there will be a helmet boolean, that will be used in animations. thats how it will calculate which sprites to use
#some ideas on how this should work - physical attacks will break the helmet, magical ones will bypass it
#helmet blocks 1 attack, enemy can also use it's shield to stun the player
@export var shielded = false
@export var helmet = true
@export var maxhealth : float = 8
@export var health : float = maxhealth
@export var speed = 50
@export var damage :float = 3
@export var attackcooldown = 1.8
@export var cantakedamage = true
@export var target = self
@export var stunned = false
@export var animationname = "default"
var onshieldcooldown = false
var inattackzone = false
var onattackcooldown = false
var dir := Vector2.ZERO
var dead = false
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")

func _ready() -> void:
	$HealthBar.max_value = maxhealth

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

func hit(selfdamage) -> void:
	if shielded:
		player.stun()
	else:
		if helmet:
			helmet = false
		else:
			health -= selfdamage
			$AnimationPlayer.play("hit")

func swordattack() -> void:
	$AttackLength.start()

func shield() -> void:
	shielded = true
	$HealthBar.tint_progress = Color8(255,255,255)
	await get_tree().create_timer(1.2).timeout
	onshieldcooldown = true
	$HealthBar.tint_progress = Color8(128, 41, 41)
	$ShieldCooldown.start()
	shielded = false

func attackroll() -> void:
	match randi_range(1,2):
		1:
			animationname = "sword"
			swordattack()
		2:
			if onshieldcooldown:
				attackroll()
			else:
				animationname = "shield"
				shield()
	onattackcooldown = true
	$AttackCooldown.start()

func _process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0 and !dead:
		death()
	elif !dead:
		if health != maxhealth:
			$HealthBar.visible = true
			$HealthBar.value = health
		if !stunned:
			if inattackzone and !onattackcooldown and inattackzone:
				attackroll()
			if target != self:
				if global_position.distance_to(target.global_position) > 220:
					target = self
				else:
					$NavigationAgent2D.target_position = target.global_position
					dir = $NavigationAgent2D.get_next_path_position() - global_position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
					if dir.length_squared() > 1.0:
						dir = dir.normalized()
						velocity = dir * Vector2(speed, speed)
		$AnimatedSprite2D.play(str(animationname, helmet))
	move_and_slide()


func _on_detection_body_entered(body: Node2D) -> void:
	target = body
	$HealthBar.visible = true
	$HealthBar.value = health


func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false
	animationname = "default"


func _on_attack_range_body_entered(_body: Node2D) -> void:
	inattackzone = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()


func _on_shield_cooldown_timeout() -> void:
	onshieldcooldown = false


func _on_attack_range_body_exited(_body: Node2D) -> void:
	inattackzone = false


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	body.hit(damage)
	$AttackHitbox/CollisionShape2D.set_deferred("disabled", true)


func _on_attack_length_timeout() -> void:
	$AttackHitbox.rotation = get_angle_to(target.global_position) + deg_to_rad(90)
	$AttackHitbox/CollisionShape2D.set_deferred("disabled", false)
