extends CharacterBody2D
#this enemy will heal itself upon damaging the player, will be able to have an overheal

@export var maxhealth : float = 4.0
@export var health : float = maxhealth
@export var speed = 70
@export var damage :float = 1
@export var attackcooldown = 0.8
@export var cantakedamage = true
@export var target = self
@export var stunned = false
@export var animationname = "default"
@export var seentarget = false
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
	player.globalcharacterstats.Xp += 5 + player.arcadeStats.get("more XP per kill")
	player.addpoints(5)
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

func hit(selfdamage) -> void:
	health -= selfdamage
	$AnimationPlayer.play("hit")



func attack() -> void:
	if !onattackcooldown:
		onattackcooldown = true
		target.hit(damage)
		health += 1.0
		$AttackCooldown.start()

func _process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0 and !dead:
		death()
	elif !dead:
		if health != maxhealth or target != self:
			$HealthBar.visible = true
			$HealthBar.value = health
			if health > maxhealth:
				$HealthBar.size.y = 2.0
				$HealthBar.modulate = Color8(255, 0, 0)
			else:
				$HealthBar.modulate = Color8(255, 255, 255)
		if !stunned:
			if inattackzone and !onattackcooldown:
				attack()
			if target != self:
				$RayCast2D.target_position = target.global_position - global_position
				if $RayCast2D.get_collider() == null:
					seentarget = true
					$RayCast2D.enabled = false
				else:
					seentarget = false
				if global_position.distance_to(target.global_position) > 220:
					target = self
				else:
					if seentarget:
						if onattackcooldown:
							$NavigationAgent2D.target_position = global_position + Vector2(randf_range(-250, 250), randf_range(-250, 250))
						else:
							$NavigationAgent2D.target_position = target.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
						dir = $NavigationAgent2D.get_next_path_position() - global_position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
						if dir.length_squared() > 1.0:
							dir = dir.normalized()
							velocity = dir * Vector2(speed, speed)
	move_and_slide()

func _on_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
		$RayCast2D.target_position = target.global_position - global_position
		$RayCast2D.enabled = true

func _on_detection_body_exited(_body: Node2D) -> void:
	target = self

func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false
	animationname = "default"


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		inattackzone = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()



func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inattackzone = false
