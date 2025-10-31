extends CharacterBody2D
#attacks: throw scythe at player, teleport behind player, summon flying souls as projectiles that add a wither effect to the player, at low hp he will teleport to the player and keep teleporting around the player while bararging them with attacks.

#essential stats
@export var maxhealth : float = 25.0
@export var health : float = maxhealth
@export var speed = 50
@export var damage :float = 3
@export var attackcooldown = 1.8
@export var cantakedamage = true
@export var target = self
@export var stunned = false
@export var animationname = "default"
var inattackzone = false
var onattackcooldown = false
var dir := Vector2.ZERO
var dead = false
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")

func _ready() -> void:
	$HealthBar.max_value = maxhealth
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
	print("attack 1")

func attack2() -> void:
	print("attack 2")

func attack3() -> void:
	print("attack 3")

func attackroll() -> void:
	if !dead:
		match randi_range(1,3): #make sure to change the length of this
			1:
				attack1()
			2:
				attack2()
			3:
				attack3()
		onattackcooldown = true
		$AttackCooldown.start()

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
			if target != self:
				if global_position.distance_to(target.global_position) > 220:
					target = self
				else:
					$NavigationAgent2D.target_position = target.global_position
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
	animationname = "default"


func _on_attack_range_body_entered(_body: Node2D) -> void:
	inattackzone = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()


func _on_attack_range_body_exited(_body: Node2D) -> void:
	inattackzone = false


func _on_detection_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
