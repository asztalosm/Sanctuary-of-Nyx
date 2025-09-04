extends CharacterBody2D
@export var maxhealth : float = 20
@export var health : float = 15.0
@export var speed = 80
@export var critchance = 10
@export var dodgechance = 10
@export var changingcharacter = false
@export var Characters = [
	{ #assassin
		"Class": "Assassin",
		"Type": "Melee",
		"Ability": "assassinstep",
		"Icon": preload("res://resources/assassinicon.png"),
		"Attack": "daggerattack",
	},
	{ #mage
		"Class": "Mage",
		"Type": "Projectile",
		"Ability": "explosionorb",
		"Icon": preload("res://resources/temporarybadwizardbase.png"),
		"Attack": "mageattack",	
	}
]
@export var globalcharacterstats = {
	"Level": 1,
	"Xp": 0,
	"XptoNextLevel": 200,
	"SkillPoints": 0,
	"BasePhysAttack": 2,
	"BaseDefense": 0,
}
@export var currentcharacter = { #this has to be reloaded every time a character change will happen, with the correct information
	"Class": "Assassin",
	"Attack": "daggerattack",
	"Ability": "assassinstep",
	"Icon": preload("res://resources/assassinicon.png"),
}
#inventory menu is a TODO, have to change the resolution of the inventory.png
@export var equipped = { #dont know yet if these should be null as in character has nothing to start with or has some basic items,
	"Head": null,
	"Chest": null,
	"Leggings": null,
	"Ring": null,
	"Hand": null,
	"Ability": null
}
@export var skills = {
	"PhysAtk": 0,
	"Defense": 0,
	"Dodge": 0,
	"Health": 0
}
@export var abilitywaittime = 4.0
@export var abilityduration = 1.0
@export var usedability = false
@export var abilityinuse = false
@export var cantakedamage = true
@export var defense = 0
var oldspeed = speed
var attacked = false
var hitenemies = []

func switchcharacter(character):
	if !changingcharacter:
		print(changingcharacter)
		changingcharacter = true
		for elements in Characters:
			if elements.Class == currentcharacter.Class:
				elements = currentcharacter
		currentcharacter = character
		$GPUParticles2D.restart()


func _ready() -> void:
	$Hitcheck.monitoring = false	
func death() -> void:
	#there will be a death animation that will be played before the death screen comes up
	var deathtween = get_tree().create_tween()
	deathtween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	$GUI/DeathScreen.visible = true
	for nodes in $GUI.get_children():
		if nodes.name != "DeathScreen":
			nodes.visible = false
		else:
			nodes.visible = true
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
	oldspeed = speed
	speed = oldspeed * 1.5
func attack() -> void:
	if !attacked:
		attacked = true
		hitenemies.clear()
		$Hitcheck.position.y += 12000
		$Hitcheck.monitoring = true
		$Hitcheck.position.y -= 12000 #pretty ugly way to reset the hitbox but idc
		$Hitcheck.rotate($Hitcheck.get_angle_to(get_global_mouse_position()) +0.5*PI)
		$Hitcheck/AnimatedSprite2D.play("default")
		$Soundcontroller.play(currentcharacter.Attack)
func hit(selfdamage) ->void:
	var dodgerng = randi_range(0,100)
	if dodgerng <= dodgechance:
		$VFXController.play("dodge")
	else:
		health -= selfdamage - skills.Defense
		$Soundcontroller.play("hit")
		if health <= 0:
			print("character died") #todo, play a death animation, add dodge stat
		else:
			$VFXController.play("invulnerability")
func calculateanimation(direction): #ugly if statements, but will work for now
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		if direction.y < 0:
			$AnimatedSprite2D.play(currentcharacter.Class+"walk4")
		elif direction.y == 0:
			$AnimatedSprite2D.play(currentcharacter.Class+"walk3")
		else:
			$AnimatedSprite2D.play(currentcharacter.Class+"walk2")
	elif direction.x == 0:
		$AnimatedSprite2D.flip_h = false
		if direction.y < 0:
			$AnimatedSprite2D.play(currentcharacter.Class+"walk5")
		else:
			$AnimatedSprite2D.play(currentcharacter.Class+"walk1")
	else:
		$AnimatedSprite2D.flip_h = false
		if direction.y < 0:
			$AnimatedSprite2D.play(currentcharacter.Class+"walk4")
		elif direction.y == 0:
			$AnimatedSprite2D.play(currentcharacter.Class+"walk3")
		else:
			$AnimatedSprite2D.play(currentcharacter.Class+"walk2")
func charactercheckchange():
	if Input.is_action_just_pressed("1"):
		switchcharacter(Characters[0])
	elif Input.is_action_just_pressed("2"):
		switchcharacter(Characters[1])

func _physics_process(_delta: float) -> void:
	charactercheckchange()
	if health <= 0:
		death()
	else:
		if globalcharacterstats.Xp >= globalcharacterstats.XptoNextLevel:
			globalcharacterstats.Xp -= globalcharacterstats.XptoNextLevel
			globalcharacterstats.Level += 1
			globalcharacterstats.SkillPoints += 1
			globalcharacterstats.XptoNextLevel += 200
			$Soundcontroller.play("LevelUp")
		var direction = Input.get_vector("Left", "Right", "Up", "Down")
		if direction: #movement
			velocity = direction * speed
			calculateanimation(direction)
		else:
			velocity = Vector2(0,0)
			if velocity == Vector2(0.0, 0.0):
					$AnimatedSprite2D.play(currentcharacter.Class+"idle")
		
		if Input.is_action_just_pressed("Attack") or Input.is_action_pressed("Attack"):
			attack()
		if Input.is_action_just_pressed("Ability"):
			if !usedability:
				ability()
		move_and_slide()



func _attack_animation_finished() -> void:
	$Hitcheck.monitoring = false
	attacked = false
	if currentcharacter.Class == "Assassin":
		for enemies in hitenemies:
			enemies.health -= globalcharacterstats.BasePhysAttack * (skills.PhysAtk + 10) / 10
			enemies.get_node("AnimationPlayer").play("hit")


func _on_hitcheck_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent().name == "Enemies":
		hitenemies.append(area.get_parent())


func ability_timeout() -> void:
	usedability = false
	$GUI/Ability.visible = false


func ability_duration_timeout() -> void:
	$GUI/Ability/TextureProgressBar.modulate = Color(1,1,1)
	speed = oldspeed
	$GUI/Ability/Cooldown.start()
	abilityinuse = false
	


func sprite_animation_changed() -> void:
	var animname : String = $AnimatedSprite2D.animation
	if animname.contains("walk"):
		$Soundcontroller.play("footstepstart")
	elif animname == "frontidle":
		$Soundcontroller.play("footstepend")


func characterswitched() -> void:
	changingcharacter = false
	print(changingcharacter)
