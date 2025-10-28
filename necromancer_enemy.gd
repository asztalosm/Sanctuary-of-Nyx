extends CharacterBody2D

@export var summoncount = 2
@export var maxhealth : float = 10
@export var health : float = maxhealth
@export var speed = 50
@export var damage :float = 5
@export var attackcooldown = 4
@export var cantakedamage = true
@export var target = self
var onattackcooldown = false
var dir := Vector2.ZERO
var dead = false
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")

func hit(selfdamage) -> void:
	health -= selfdamage
	$AnimationPlayer.play("hit")

func _ready() -> void:
	$HealthBar.max_value = maxhealth
	$SummonTime.wait_time = attackcooldown
func death() -> void:
	dead = true
	player.globalcharacterstats.Xp += 30 + player.arcadeStats.get("more XP per kill")
	player.addpoints(15)
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
	if onattackcooldown == false:
		onattackcooldown = true
		$AnimatedSprite2D.play("attack")


func _physics_process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0 and !dead:
		death()
	elif !dead:
		$HealthBar.visible = true
		$HealthBar.value = health
		if target != self :
			if global_position.distance_to(target.global_position) > 220:
				target = self
			else:
				if $NavigationAgent2D.is_target_reached():
					attack()
				$NavigationAgent2D.target_position = (global_position - target.global_position) * Vector2(100, 100)
				dir = $NavigationAgent2D.get_next_path_position() - global_position
				if dir.length_squared() > 1.0:
						dir = dir.normalized()
						velocity = dir * speed
	
	move_and_slide()


func _on_detection_body_entered(body: Node2D) -> void:
		target = body
		$Detection.scale = Vector2(2,2)
		attack()


func _on_summon_time_timeout() -> void:
	onattackcooldown = false


func _on_gpu_particles_2d_finished() -> void:
	queue_free()


func _on_detection_body_exited(_body: Node2D) -> void:
	target = self


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		for i in range(summoncount):
			var summon = preload("res://skeleton_summon.tscn").instantiate()
			await get_tree().create_timer(0.1).timeout #added this line so the debugger stops bitching about 4 area2d's being worked with at the same time
			get_parent().add_child(summon)
			$SummonTime.start()
			summon.global_position = global_position + Vector2(randi_range(-48, 48), randi_range(-48, 48))
