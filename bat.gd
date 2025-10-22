extends CharacterBody2D
#this enemy will heal itself upon damaging the player, will be able to have an overheal

@export var maxhealth : float = 4.0
@export var health : float = maxhealth
@export var speed = 50
@export var damage :float = 1
@export var attackcooldown = 0.8	
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
	player.globalcharacterstats.Xp += 5 + player.arcadeStats.get("more XP per kill")
	player.addpoints(5)
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
				if global_position.distance_to(target.global_position) > 220:
					target = self
				else:
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
	target = body
	$HealthBar.visible = true
	$HealthBar.value = health

func _on_detection_body_exited(_body: Node2D) -> void:
	target = self

func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false
	animationname = "default"


func _on_attack_range_body_entered(_body: Node2D) -> void:
	inattackzone = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()



func _on_attack_range_body_exited(_body: Node2D) -> void:
	inattackzone = false
