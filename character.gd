extends CharacterBody2D
@export var maxhealth = 20
@export var health = 15
@export var speed = 80
@export var critchance = 10
@export var currentcharacter = { #this has to be reloaded every time a character change will happen, with the correct information
	"Class": "Assassin",
	"Attacksound": "daggerattack",
	"Ability": "assassinstep"
}
@export var abilitywaittime = 4.0
@export var abilityduration = 1.0
@export var usedability = false
@export var abilityinuse = false
@export var cantakedamage = true
var attacked = false
var hitenemies = []


func _ready() -> void:
	$Hitcheck.monitoring = false	
func death() -> void:
	#there will be a death animation that will be played before the death screen comes up
	var deathtween = get_tree().create_tween()
	deathtween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	$GUI/DeathScreen.visible = true
	deathtween.tween_property($GUI/DeathScreen, "modulate:a", 1, 1.0)
	$Soundcontroller.stop()
	$Soundcontroller.play("death")
	get_tree().paused = true
func ability() -> void:
	abilityinuse = true
	usedability = true
	$GUI/Ability.visible = true
	$GUI/Ability/TextureProgressBar.modulate = Color(0.5,0.5,1)
	$GUI/Ability/Cooldown.wait_time = abilitywaittime
	$GUI/Ability/AbilityDuration.wait_time = abilityduration
	$GUI/Ability/AbilityDuration.start()
	$Soundcontroller.play(currentcharacter.Ability)
	speed = 140
func attack() -> void:
	if !attacked:
		attacked = true
		hitenemies.clear()
		$Hitcheck.position.y += 12000
		$Hitcheck.monitoring = true
		$Hitcheck.position.y -= 12000 #pretty ugly way to reset the hitbox but idc
		$Hitcheck.rotate($Hitcheck.get_angle_to(get_global_mouse_position()) +0.5*PI)
		$Hitcheck/AnimatedSprite2D.play("default")
		$Soundcontroller.play(currentcharacter.Attacksound)
func hit(selfdamage) ->void:
	health -= selfdamage
	$Soundcontroller.play("hit")
	if health <= 0:
		print("no invulnerabilty animation because character is already dead")
	else:
		$VFXController.play("invulnerability")

func _physics_process(_delta: float) -> void:
	if health <= 0:
		death()
	else:
		var directionx = Input.get_axis("Left", "Right")
		var directiony = Input.get_axis("Up", "Down")
		if directionx or directiony: #movement
			velocity.x = directionx * speed
			velocity.y = directiony * speed
			$AnimatedSprite2D.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)
			if velocity == Vector2(0.0,0.0):
				$AnimatedSprite2D.play("default")
		
		if Input.is_action_just_pressed("Attack") or Input.is_action_pressed("Attack"):
			attack()
		if Input.is_action_just_pressed("Ability"):
			if !usedability:
				ability()
		move_and_slide()



func _attack_animation_finished() -> void:
	$Hitcheck.monitoring = false
	attacked = false
	for enemies in hitenemies:
		enemies.health -= 3
		enemies.get_node("AnimationPlayer").play("hit")


func _on_hitcheck_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent().name == "Enemies":
		hitenemies.append(area.get_parent())


func ability_timeout() -> void:
	usedability = false
	$GUI/Ability.visible = false


func ability_duration_timeout() -> void:
	$GUI/Ability/TextureProgressBar.modulate = Color(1,1,1)
	speed = 80
	$GUI/Ability/Cooldown.start()
	abilityinuse = false
	


func sprite_animation_changed() -> void:
	if $AnimatedSprite2D.animation == "default":
		$Soundcontroller.play("footstepend")
	elif $AnimatedSprite2D.animation == "walk":
		$Soundcontroller.play("footstepstart")
