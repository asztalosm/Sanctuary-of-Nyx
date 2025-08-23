extends CharacterBody2D
@export var maxhealth = 20
@export var health = maxhealth
@export var speed = 80
@export var critchance = 10
var attacked = false
var hitenemies = []
func _ready() -> void:
	$Hitcheck.monitoring = false
	
	
	
func _physics_process(delta: float) -> void:
	var directionx = Input.get_axis("Left", "Right")
	var directiony = Input.get_axis("Up", "Down")
	if directionx or directiony:
		velocity.x = directionx * speed
		velocity.y = directiony * speed
		$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		if velocity == Vector2(0.0,0.0):
			$AnimatedSprite2D.play("default")
	
	if Input.is_action_just_pressed("Attack"):
		if !attacked:
			attacked = true
			hitenemies.clear()
			$Hitcheck.position.y += 12000
			$Hitcheck.monitoring = true
			$Hitcheck.position.y -= 12000 #pretty ugly way to reset the hitbox but idc
			$Hitcheck.rotate($Hitcheck.get_angle_to(get_global_mouse_position()) +0.5*PI)
			$Hitcheck/AnimatedSprite2D.play("default")
		
	if Input.is_action_pressed("Attack"):
		if !attacked:
			attacked = true
			hitenemies.clear()
			$Hitcheck.position.y += 12000
			$Hitcheck.monitoring = true
			$Hitcheck.position.y -= 12000
			$Hitcheck.rotate($Hitcheck.get_angle_to(get_global_mouse_position()) +0.5*PI)
			$Hitcheck/AnimatedSprite2D.play("default")
		
	move_and_slide()



func _attack_animation_finished() -> void:
	$Hitcheck.monitoring = false
	attacked = false


func _on_hitcheck_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent().name == "Enemies":
		hitenemies.append(area)
	print(hitenemies)
