extends CharacterBody2D
@export var arcadeStats = { #all will be set to 0 and arcade script will change these
	"hp": 0.0,
	"dmg": 0.0,
	"dodge_chance": 0.0,
	"mov_spd": 0.0,
	"crit_chance": 0.0,
	"def": 0.0,
	"xp_multiplier": 0.0,
	"more XP per kill": 0.0,
	"lifesteal": 0.0
}
@export var maxhealth : float = 20.0 + arcadeStats.hp
@export var health : float = maxhealth
@export var speed = 80 + arcadeStats.mov_spd
@export var critchance = 10 + arcadeStats.crit_chance
@export var dodgechance = 10 + arcadeStats.dodge_chance
@export var changingcharacter = false
@export var points = 0
@export var Characters = [
	{ #assassin
		"Class": "Assassin",
		"Type": "Melee",
		"Ability": "assassinstep",
		"AbilityCooldown": 2,
		"AbilityDuration": 1.2,
		"Icon": preload("res://resources/assassinicon.png"),
		"Attack": "daggerattack",
		"AttackType": "Physical"
	},
	{ #mage
		"Class": "Mage",
		"Type": "Projectile",
		"Ability": "stun",
		"AbilityCooldown": 5,
		"AbilityDuration": 3,
		"Icon": preload("res://resources/temporarybadwizardbase.png"),
		"Attack": "mageattack",	
		"AttackType": "Magical"
	}
]
@export var globalcharacterstats = {
	"Level": 1,
	"Xp": 0,
	"XptoNextLevel": 200,
	"SkillPoints": 0,
	"BasePhysAttack": 2 + arcadeStats.dmg,
	"BaseDefense": 0 + arcadeStats.def,
	"BaseMagicAttack": 2.5 + arcadeStats.dmg,
	"xpMultiplier": 1.0 + arcadeStats.xp_multiplier
}
@export var currentcharacter = { #this has to be reloaded every time a character change will happen, with the correct information
	"Class": "Assassin",
	"Type": "Melee",
	"Ability": "assassinstep",
	"AbilityCooldown": 2,
	"AbilityDuration": 1.2,
	"Icon": preload("res://resources/assassinicon.png"),
	"Attack": "daggerattack",
	"AttackType": "Physical"
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
	"Health": 0,
	"MagicAtk": 0,
	"AtkSpeed": 0
}
@export var usedability = false
@export var abilityinuse = false
@export var cantakedamage = true
var oldspeed = speed
var attacked = false
var hitenemies = []
#skill tree with cursed branches
#cursed branch can only be obtained after fighting a boss - your character will get MASSIVE debuffs AND buffs and new attacks, point redistribution would be expensive and give the player a challenge in the open world
#chatgpt kinda cooked with the cursed branch idea

func addpoints(value):
	points += int(value * globalcharacterstats.xpMultiplier)

func switchcharacter(character):
	if !changingcharacter and character != currentcharacter:
		attacked = false #i guess this could be exploited to reset atk cd but idc cause there already is a cd on character change
		changingcharacter = true
		for elements in Characters:
			if elements.Class == currentcharacter.Class:
				elements = currentcharacter
		currentcharacter = character
		$GPUParticles2D.restart()

func _ready() -> void:
	$AssassinHitcheck.monitoring = false	
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
	if currentcharacter.Ability == "assassinstep":
		oldspeed = speed
		speed = oldspeed * 1.75
	if currentcharacter.Ability == "stun":
		var stunSpriteTween = get_tree().create_tween()
		$MageAbility/CollisionShape2D.set_deferred("disabled", false)
		$MageAbility/Timer.start()
		stunSpriteTween.set_parallel(true)
		stunSpriteTween.tween_property($MageAbility, "modulate", Color8(255,255,255,255), 0.1)
		stunSpriteTween.tween_property($MageAbility, "scale", Vector2(12,12), 2)
	$GUI/Ability.visible = true
	$GUI/Ability/TextureProgressBar.modulate = Color(0.5,0.5,1)
	$GUI/Ability/Cooldown.wait_time = currentcharacter.AbilityCooldown
	$GUI/Ability/AbilityDuration.wait_time = currentcharacter.AbilityDuration
	$GUI/Ability/AbilityDuration.start()
	$Soundcontroller.play(currentcharacter.Ability)


func attack() -> void:
	if attacked:
		return
	else:
		attacked = true
		hitenemies.clear()
		if currentcharacter.Attack == "daggerattack":
			$AssassinHitcheck.position.y += 12000
			$AssassinHitcheck.monitoring = true
			$AssassinHitcheck.position.y -= 12000 #pretty ugly way to reset the hitbox but idc
			$AssassinHitcheck.rotate($AssassinHitcheck.get_angle_to(get_global_mouse_position()) +0.5*PI)
			$AssassinHitcheck/AnimatedSprite2D.speed_scale = 1 + skills.AtkSpeed * 0.025 # also makes the cd faster 
			$AssassinHitcheck/AnimatedSprite2D.play("default")
			$Soundcontroller/attack.pitch_scale = randf_range(0.9, 1.25)
			$Soundcontroller.play(currentcharacter.Attack)
		if currentcharacter.Attack == "mageattack":
			$MageProjectile/MageHitcheck.set_deferred("monitoring", true)
			$MageProjectile/MageHitcheck/Timer.wait_time = 1.8 - skills.AtkSpeed * 0.025
			$MageProjectile.speed = 220 * (1 + skills.AtkSpeed * 0.025)
			$MageProjectile.start()
func applydamage() -> void:
	var damage = 0
	if currentcharacter.Class == "Assassin": #todo: calculate damage, based on equipment and base class stats
		$AssassinHitcheck.monitoring = false
		attacked = false
	if currentcharacter.Class == "Mage":
		$MageProjectile/MageHitcheck.set_deferred("monitoring", false)
		#for equipment in equipped:
			#if equipment != null:
				#print(equipment)
	
	
	for enemies in hitenemies:
		if currentcharacter.AttackType == "Magical":
			damage = (globalcharacterstats.BaseMagicAttack + arcadeStats.dmg) * (skills.MagicAtk + 10) / 10
		elif currentcharacter.AttackType == "Physical":
			damage = (globalcharacterstats.BasePhysAttack + arcadeStats.dmg) * (skills.PhysAtk + 10) / 10
		if randi_range(1,100) <= critchance:
			$AssassinHitcheck/AnimatedSprite2D.modulate = Color8(255,128,128)
			damage *= 1.5
		print(arcadeStats.lifesteal)
		if (enemies.health - damage) <= 0.0:
			if (health + arcadeStats.lifesteal) < maxhealth- arcadeStats.lifesteal:
				health = maxhealth
			health += arcadeStats.lifesteal
		enemies.get_node("AnimationPlayer").play("hit")
		enemies.health -= damage

func hit(selfdamage, dodgeable = true) ->void:
	var dodgerng = randi_range(0,100)
	if dodgerng <= dodgechance + arcadeStats.dodge_chance and dodgeable:
		$VFXController.play("dodge")
	else:
		if cantakedamage:
			if selfdamage <= 0:
				health -= 0.1
			else:
				health -= selfdamage #TODO balancing changes with this
			cantakedamage = false
			$Soundcontroller/hit2.pitch_scale = randf_range(0.85, 1.15)
			$Soundcontroller.play("hit")
			var cameratween = get_tree().create_tween()
			cameratween.tween_property($Camera2D, "offset", Vector2(randf_range(-5,5), randf_range(-5,5)), 0.05)
			cameratween.tween_property($Camera2D, "offset", Vector2.ZERO, 0.3)
			if health <= 0:
				return
				#print("character died") #todo, play a death animation, add dodge stat
			else:
				$VFXController.play("invulnerability")
				await get_tree().create_timer(0.3).timeout
				cantakedamage = true

func calculateanimation(direction): #ugly if statements, but will work for now
	if usedability:
		$AnimatedSprite2D.speed_scale = 1.25
	else:
		$AnimatedSprite2D.speed_scale = 1.0 # i guess this fixes an animation issue dont know why but good i guess
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
	$AssassinHitcheck/AnimatedSprite2D.modulate = Color8(255,255,255)
	applydamage()


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
	elif animname.contains("idle"):
		$Soundcontroller.play("footstepend")


func characterswitched() -> void:
	changingcharacter = false

func _on_stun_area_entered(area: Area2D) -> void:
	if abilityinuse:
		area.get_parent().set_process(false)
		area.get_parent().set_physics_process(false)
		print(area.get_parent())
		await get_tree().create_timer(2).timeout
		area.get_parent().set_process(true)
		area.get_parent().set_physics_process(true)


func _on_timer_timeout() -> void: #stun timer
	var stunSpriteTween = get_tree().create_tween()
	stunSpriteTween.set_parallel(false)
	$MageAbility/CollisionShape2D.set_deferred("disabled", true)
	stunSpriteTween.tween_property($MageAbility, "scale", Vector2(1,1), 0.1)
	stunSpriteTween.tween_property($MageAbility, "modulate", Color8(255,255,255,0), 0.1)
