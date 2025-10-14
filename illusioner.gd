extends CharacterBody2D
@export var maxhealth : float = 4
@export var health : float = maxhealth
@export var speed = 50
@export var damage :float = 4
@export var cantakedamage = true
@export var target = self
@export var stunned = false
var attacked = false
var dir := Vector2.ZERO
@export var dead = false
@export var original = true

func _ready() -> void:
	if !original:
		$GPUParticles2D.restart()
	$HealthBar.max_value = maxhealth

func hit(selfdamage) -> void:
	health -= selfdamage
	$AnimationPlayer.play("hit")

func summonself(count, path) -> void:
	if !attacked:
		$GPUParticles2D.restart()
		for i in range(count):
			var selfscene = preload("res://illusioner.tscn").instantiate()
			path.call_deferred("add_child", selfscene)
			selfscene.top_level = true
			selfscene.global_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
			global_position = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
			selfscene.target = target
			selfscene.name = "Illusion"
			selfscene.original = false
	attacked = true

func death() -> void:
	if original:
		dead = true
		var player = get_parent().get_parent().get_node("Character").get_node("Player")
		player.globalcharacterstats.Xp += 20 + player.arcadeStats.get("more XP per kill")
		player.addpoints(10)
		$GPUParticles2D.restart()
		for children in get_children():
			if children != $GPUParticles2D:
				children.queue_free()
	else:
		var player = get_parent().get_parent().get_parent().get_node("Character").get_node("Player")
		summonself(1, get_parent())
		player.hit(3,false, true)
		queue_free()

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
				if global_position.distance_to(target.global_position) < 70:
					$NavigationAgent2D.target_position = (global_position - target.global_position) * Vector2(100, 100)
					dir = $NavigationAgent2D.get_next_path_position() - global_position
				else:
					$NavigationAgent2D.target_position = target.global_position
					dir = Vector2.ZERO
					#old : $NavigationAgent2D.get_next_path_position() - global_position + Vector2(randf_range(-15, 15), randf_range(-15, 15))
				if global_position.distance_to(target.global_position) > 180:
					target = self
				else:
					if dir.length_squared() > 1.0:
						dir = dir.normalized()
						velocity = dir * speed
	move_and_slide()

func _on_detection_body_entered(body: Node2D) -> void:
	target = body
	$Detection.scale = Vector2(2,2)
	if original:
		summonself(2, self)

func _on_attack_cooldown_timeout() -> void:
	return

func _on_gpu_particles_2d_finished() -> void:
	if dead:
		queue_free()

func _on_detection_body_exited(_body: Node2D) -> void:
	target = self
