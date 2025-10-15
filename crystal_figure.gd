extends CharacterBody2D
#this enemy will attack the player with shards, will have multiple attacks like bosses:
#attacks: shard like an arrow, set shards on floor like a minecraft evoker, and wall off the player with a solid wall that damages the player on contact


@export var shielded = false
@export var maxhealth : float = 25.0
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
	player.globalcharacterstats.Xp += 100 + player.arcadeStats.get("more XP per kill")
	player.addpoints(200)
	$GPUParticles2D.restart()
	for nodes in self.get_children():
		if nodes != $GPUParticles2D:
			nodes.queue_free()

func hit(selfdamage) -> void:
	if shielded:
		player.stun()
	else:
		health -= selfdamage
		$AnimationPlayer.play("hit")

func shield() -> void:
	shielded = true
	$HealthBar.tint_progress = Color8(255,255,255)
	await get_tree().create_timer(1.2).timeout
	onshieldcooldown = true
	$HealthBar.tint_progress = Color8(128, 41, 41)
	$ShieldCooldown.start()
	shielded = false

func shardprojectile() -> void:
	print("shardprojectile")

func attackroll() -> void:
	match randi_range(1,2):
		1:
			shardprojectile()
		2:
			print("attack2")
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


func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false
	animationname = "default"


func _on_attack_range_body_entered(body: Node2D) -> void:
	inattackzone = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()


func _on_shield_cooldown_timeout() -> void:
	onshieldcooldown = false


func _on_attack_range_body_exited(body: Node2D) -> void:
	inattackzone = false
