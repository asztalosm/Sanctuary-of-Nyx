extends CharacterBody2D
#attacks: throw scythe at player, teleport behind player, summon flying souls as projectiles that add a wither effect to the player, at low hp he will teleport to the player and keep teleporting around the player while bararging them with attacks.

#essential stats
@export var maxhealth : float = 25.0
@export var health : float = maxhealth
@export var speed = 80
@export var damage :float = 3
@export var attackcooldown = 1.8
@export var cantakedamage = true
@export var target = self
@export var stunned = false
@export var animationname = "default"
@export var sunattacking = false
@export var moonattacking = false
var inattackzone = false
var onattackcooldown = false
var dir := Vector2.ZERO
var dead = false
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")
var canmove = true
func _ready() -> void:
	$HealthBar.max_value = maxhealth
	$Attacks/Sun.modulate = Color(1.0,1.0,1.0, 0.3)
	$Attacks/Moon.modulate = Color(1.0,1.0,1.0, 0.3)
	

func spawnmoonprojectile() -> void:
	for i in range(8):
		var moonprojectilescene = load("res://moon_projectile.tscn").instantiate()
		get_parent().add_child(moonprojectilescene)
		var moonscale = randf_range(0.5, 1.25)
		moonprojectilescene.scale = Vector2(moonscale, moonscale)
		moonprojectilescene.global_position = player.global_position + Vector2(randf_range(-75.0,75.0), randf_range(-75.0,75.0))

func stun() -> void:
	stunned = true
	var stuntime = 2.0
	var stunscene = load("res://stun.tscn").instantiate()
	stunscene.global_position = global_position + Vector2(0,-42)
	stunscene.sprite_frames.set_animation_speed("default", 7 / stuntime)
	stunscene.play("default")
	self.add_child(stunscene)
	await get_tree().create_timer(stuntime).timeout
	stunned = false

func death() -> void:
	dead = true
	player.globalcharacterstats.Xp += 250 + player.arcadeStats.get("more XP per kill")
	player.addpoints(250)
	$GPUParticles2D.restart()
	for nodes in self.get_children():
		if nodes != $GPUParticles2D:
			nodes.queue_free()

func hit(selfdamage) -> void:
	health -= selfdamage
	$AnimationPlayer.play("hit")

func attack1() -> void:
	#sun
	damage = 1.0
	$AttackDuration.wait_time = 1.8
	canmove = false
	$Attacks/Sun2.rotation = get_angle_to(player.global_position) - 0.5*PI
	$Attacks/Sun.modulate = Color(1.0,1.0,1.0, 1.0)
	await get_tree().create_timer(0.1).timeout
	if dead:
		return
	$Attacks/Sun2/GPUParticles2D2.emitting = true
	await get_tree().create_timer(0.2).timeout #time to show the player what the attack will be
	if dead:
		return
	$Attacks/Sun2.collision_mask = 4
	sunattacking = true
	$AttackDuration.start()
	$Attacks/Sun2/AudioStreamPlayer2D.volume_db = MenuMusic.setsfx()
	$Attacks/Sun2/AudioStreamPlayer2D.play()
	$Attacks/Sun.modulate = Color(1.0,1.0,1.0, 0.3)

func attack2() -> void:
	#moon
	canmove = false
	moonattacking = true
	$AttackDuration.wait_time = 1.8
	$AttackDuration.start()
	$Attacks/Moon.modulate = Color(1.0,1.0,1.0, 1.0)
	await get_tree().create_timer(0.3).timeout #time to show the player what the attack will be
	if dead:
		return
	$Attacks/Moon2/HitDelay.start()
	spawnmoonprojectile()
	$Attacks/Moon.modulate = Color(1.0,1.0,1.0, 0.3)


func attackroll() -> void:
	if !dead:
		match randi_range(1,2): #make sure to change the length of this
			1:
				attack1()
			2:
				attack2()
		onattackcooldown = true

func _process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0 and !dead:
		death()
	elif !dead:
		if health != maxhealth or target != self:
			$HealthBar.visible = true
			$HealthBar.value = health
		if !stunned:
			if inattackzone and !onattackcooldown and inattackzone:
				attackroll()
				
			if target != self and canmove:
				if global_position.distance_to(target.global_position) > 120:
					$NavigationAgent2D.target_position = (global_position - target.global_position) * Vector2(100, 100)
					dir = $NavigationAgent2D.get_next_path_position() - global_position
					if dir.length_squared() > 1.0:
							dir = dir.normalized()
				else:
					$NavigationAgent2D.target_position = (global_position - target.global_position) * Vector2(100,100)
					dir = $NavigationAgent2D.get_next_path_position() - global_position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
					if dir.length_squared() > 1.0:
						dir = dir.normalized()
						velocity = dir * Vector2(speed, speed)
	move_and_slide()

func _on_detection_body_entered(body: Node2D) -> void:
	target = body
	$HealthBar.visible = true
	$HealthBar.value = health


func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false
	$Attacks/Sun2/GPUParticles2D2.emitting = false
	animationname = "default"


func _on_attack_range_body_entered(_body: Node2D) -> void:
	inattackzone = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()


func _on_attack_range_body_exited(_body: Node2D) -> void:
	inattackzone = false


func _on_detection_body_exited(_body: Node2D) -> void:
	pass


func _on_sun_2_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		area.get_parent().hit(damage)


func _on_hitdelay_timeout() -> void:
	if sunattacking:
		$Attacks/Sun2/CollisionPolygon2D.position += Vector2(1,0)
		$Attacks/Sun2.collision_mask = 0
		await get_tree().create_timer(0.15).timeout
		if dead:
			return
		$Attacks/Sun2/CollisionPolygon2D.position -= Vector2(1,0)
		$Attacks/Sun2.collision_mask = 4


func _on_attack_duration_timeout() -> void:
	canmove = true
	sunattacking = false
	moonattacking = false
	$Attacks/Sun2/AudioStreamPlayer2D.stop()
	$Attacks/Sun2/GPUParticles2D2.emitting = false
	$Attacks/Sun2.collision_mask = 0
	$AttackCooldown.start()


func _on_hit_delay_timeout() -> void:
	if moonattacking:
		spawnmoonprojectile()
