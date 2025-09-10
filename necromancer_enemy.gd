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

func _ready() -> void:
	$HealthBar.max_value = maxhealth
	$SummonTime.wait_time = attackcooldown
func death() -> void:
	queue_free()

func attack() -> void:
	if onattackcooldown == false:
		onattackcooldown = true
		$AnimatedSprite2D.play("attack")
		for i in range(summoncount):
			var summon = preload("res://skeleton_summon.tscn").instantiate()
			await get_tree().create_timer(0.1).timeout #added this line so the debugger stops bitching about 4 area2d's being worked with at the same time
			get_parent().add_child(summon)
			$SummonTime.start()
			summon.global_position = global_position + Vector2(randi_range(-48, 48), randi_range(-48, 48))


func _physics_process(_delta: float) -> void:
	velocity = Vector2(0,0)
	if health <= 0:
		death()
	elif health != maxhealth:
		$HealthBar.visible = true
		$HealthBar.value = health
	if target != self:
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
		attack()


func _on_summon_time_timeout() -> void:
	onattackcooldown = false
