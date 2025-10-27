extends CharacterBody2D
@export var maxhealth : float = 10
@export var health : float = maxhealth
@export var speed = 80
@export var damage :float = 5
@export var attackcooldown = 2.0
@export var cantakedamage = true
@export var target = self
@export var stunned = false
var onattackcooldown = false
var dir := Vector2.ZERO
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")
@export var dead = false
@export var seentarget = false
func hit(selfdamage) -> void:
	health -= selfdamage
	$AnimationPlayer.play("hit")

func _ready() -> void:
	$HealthBar.max_value = maxhealth

func death() -> void:
	dead = true
	player.globalcharacterstats.Xp += 20 + player.arcadeStats.get("more XP per kill")
	player.addpoints(10)
	if get_parent().get_parent().name == "Dungeon":
		var gpuparticle = load("res://coin_particles.tscn").instantiate()
		gpuparticle.global_position = global_position
		var colorrect = ColorRect.new()
		colorrect.top_level = true
		colorrect.z_index = 100
		colorrect.global_position = global_position
		var coins = randi_range(1,8)
		gpuparticle.amount = coins
		get_parent().get_parent().coins += coins
		get_parent().add_child(gpuparticle)
	$GPUParticles2D.restart()
	for nodes in self.get_children():
		if nodes != $GPUParticles2D:
			nodes.queue_free()

func attack() -> void:
	if !onattackcooldown and target.cantakedamage and !stunned:
		$AttackCooldown.wait_time = attackcooldown
		onattackcooldown = true
		$AttackCooldown.start()
		target.hit(damage)

func stun() -> void:
	stunned = true
	await get_tree().create_timer(3.0).timeout
	stunned = false

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
				$RayCast2D.target_position = target.global_position - global_position
				if $RayCast2D.get_collider() == null:
					seentarget = true
					$RayCast2D.enabled = false
				else:
					seentarget = false
				if global_position.distance_to(target.global_position) > 220:
					target = self
				else:
					if $NavigationAgent2D.is_target_reached():
						attack()
					$NavigationAgent2D.target_position = target.global_position
					dir = $NavigationAgent2D.get_next_path_position() - global_position + Vector2(randf_range(-15, 15), randf_range(-15, 15))
					if dir.length_squared() > 1.0:
							dir = dir.normalized()
							velocity = dir * speed
	move_and_slide()




func _on_detection_body_entered(body: Node2D) -> void:
	target = body
	$RayCast2D.target_position = target.global_position - global_position
	$RayCast2D.enabled = true
	$Detection.scale = Vector2(2,2)
	$NavigationAgent2D.target_desired_distance = $Detection/AttackZone/CollisionShape2D.shape.radius /2


func _on_attack_cooldown_timeout() -> void:
	onattackcooldown = false


func _on_gpu_particles_2d_finished() -> void:
	queue_free()


func _on_detection_body_exited(_body: Node2D) -> void:
	target = self
