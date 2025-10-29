extends CharacterBody2D

@export var arrowcd = 1.5
@export var arcadeStats = { #all will be set to 0 and arcade script will change these
	"hp": 0.0,
	"dmg": 0.0,
	"dodge_chance": 0.0,
	"mov_spd": 0.0,
	"crit_chance": 0.0,
	"def": 0.0,
	"xp_multiplier": 0.0,
	"more XP per kill": 0.0,
	"lifesteal": 0.0,
	"laststand": 0.0
}
@export var regen : float = 1.0
@export var maxhealth : float = 20.0 + arcadeStats.hp
@export var health : float = maxhealth
@export var speed = 80 + arcadeStats.mov_spd
@export var critchance = 10 + arcadeStats.crit_chance
@export var dodgechance = 10 + arcadeStats.dodge_chance
@export var changingcharacter = false
@export var points = 0
@export var rolling = false
@export var Characters = [
	{ #assassin
		"Class": "Assassin",
		"Type": "Melee",
		"Ability": "assassinstep",
		"AttackDamage": 2.0,
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
		"AttackDamage": 3.0,
		"AbilityCooldown": 5,
		"AbilityDuration": 3,
		"Icon": preload("res://resources/temporarybadwizardbase.png"),
		"Attack": "mageattack",
		"AttackType": "Magical"
	},
	{ #archer
		"Class": "Archer",
		"Type": "Projectile",
		"Ability": "fastarrows",
		"AttackDamage": 3.0,
		"AbilityCooldown": 3,
		"AbilityDuration": 1,
		"Icon": preload("res://resources/temparcher.png"), #just a temp file
		"Attack": "archerattack",
		"AttackType": "Physical"
	},
	{ #knight
		"Class": "Knight",
		"Type": "Melee",
		"Ability": "berserk",
		"AttackDamage": 4.0,
		"AbilityCooldown": 8,
		"AbilityDuration": 4,
		"Icon": preload("res://resources/temporarybadwizardbase.png"),
		"Attack": "knightattack",
		"AttackType": "Physical"
	}
]
@export var globalcharacterstats = {
	"Level": 1,
	"Xp": 0,
	"XptoNextLevel": 200,
	"SkillPoints": 0,
	"BaseDefense": 0.0 + arcadeStats.def,
	"xpMultiplier": 1.0 + arcadeStats.xp_multiplier
}
@export var currentcharacter = Characters[0]

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
@export var stunned = false
var oldspeed = speed
var attacked = false
var hitenemies = []
#skill tree with cursed branches
#cursed branch can only be obtained after fighting a boss - your character will get MASSIVE debuffs AND buffs and new attacks, point redistribution would be expensive and give the player a challenge in the open world
#chatgpt kinda cooked with the cursed branch idea

func recheckstats(): #this updates the currentcharacters stats to the Character's stats, which is the one that gets updated
	for elements in Characters:
		if elements.Class == currentcharacter.Class:
			currentcharacter = elements

func addpoints(value):
	points += int(value * globalcharacterstats.xpMultiplier)

func switchcharacter(character):
	if !changingcharacter and character != currentcharacter:
		changingcharacter = true
		for elements in Characters:
			if elements.Class == currentcharacter.Class:
				elements = currentcharacter
		currentcharacter = character
		$GPUParticles2D.restart()

func stun() -> void:
	stunned = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0
	await get_tree().create_timer(1).timeout
	stunned = false

func _ready() -> void:
	switchcharacter(Characters[0])
	$AssassinHitcheck.monitoring = false
func death() -> void:
	#there will be a death animation that will be played before the death screen comes up
	var deathtween = get_tree().create_tween()
	deathtween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	$GUI/DeathScreen.visible = true
	for nodes in $GUI.get_children():
		if nodes.name != "DeathScreen":
			if nodes.name == "MenuButton":
				pass
			else:
				nodes.visible = false
		else:
			if nodes.name == "AudioStreamPlayer":
				pass
			else:
				nodes.visible = true
	deathtween.tween_property($GUI/DeathScreen, "modulate:a", 1, 1.0)
	$Soundcontroller.stop()
	$Soundcontroller.play("death")
	$GUI/DeathScreen/Restart.grab_focus()
	get_tree().paused = true
func ability() -> void:
	$Soundcontroller.play("ability")
	abilityinuse = true
	usedability = true
	$GUI/Ability.visible = true
	$GUI/Ability/TextureProgressBar.modulate = Color(0.5,0.5,1)
	$GUI/Ability/Cooldown.wait_time = currentcharacter.AbilityCooldown
	$GUI/Ability/AbilityDuration.wait_time = currentcharacter.AbilityDuration
	$GUI/Ability/AbilityDuration.start()
	$Soundcontroller.play(currentcharacter.Ability)
	match currentcharacter.Ability:
		"assassinstep":
			collision_layer = 1
			$SmokeScreen.restart()
			speed *= 1.75
			var cameratween = get_tree().create_tween()
			cameratween.tween_property($Camera2D, "offset", Vector2(randf_range(-2,2), randf_range(-2,2)), 0.15)
			cameratween.tween_property($Camera2D, "offset", Vector2.ZERO, 0.3)
			await get_tree().create_timer(currentcharacter.AbilityDuration).timeout
			speed /= 1.75
			collision_layer = 21
		"stun":
			var stunSpriteTween = get_tree().create_tween()
			$MageAbility/CollisionShape2D.set_deferred("disabled", false)
			$MageAbility/Timer.start()
			stunSpriteTween.set_parallel(true)
			stunSpriteTween.tween_property($MageAbility, "modulate", Color8(255,255,255,255), 0.1)
			stunSpriteTween.tween_property($MageAbility, "scale", Vector2(12,12), 2)
		"fastarrows":
			for i in range(5): #uses the arrow attack script now but changed cooldown
				var arrowScene = load("res://player_arrow.tscn")
				var arrow = arrowScene.instantiate()
				arrow.global_position = global_position
				arrow.dir = Vector2.from_angle(get_angle_to(get_global_mouse_position()))
				add_child(arrow)
				await get_tree().create_timer(0.35).timeout
		"berserk":
			globalcharacterstats.BaseDefense = 10
			speed /= 1.3
			await get_tree().create_timer(4).timeout
			speed *= 1.3
			globalcharacterstats.BaseDefense = 0 + arcadeStats.def

func roll() -> void:
	if !rolling:
		rolling = true
		cantakedamage = false
		$RollCooldown/CanvasLayer/TextureProgressBar.value = 0
		$RollCooldown.start()
		$VFXController.play("roll")
		speed *= 1.5
		await get_tree().create_timer(0.6).timeout
		speed /= 1.5
		cantakedamage = true

func attack() -> void:
	if attacked or rolling:
		return
	else:
		attacked = true
		match currentcharacter.Attack:
			"daggerattack":
				$AssassinHitcheck.position.y += 12000
				$AssassinHitcheck.monitoring = true
				$AssassinHitcheck.position.y -= 12000 #pretty ugly way to reset the hitbox but idc
				$AssassinHitcheck.rotate($AssassinHitcheck.get_angle_to(get_global_mouse_position()) +0.5*PI)
				$AssassinHitcheck/AnimatedSprite2D.speed_scale = 1 + skills.AtkSpeed * 0.025 # also makes the cd faster 
				$AssassinHitcheck/AnimatedSprite2D.play("default")
				$Soundcontroller/attack.pitch_scale = randf_range(0.9, 1.25)
				$Soundcontroller.play(currentcharacter.Attack)
			"mageattack":
				$MageProjectile/MageHitcheck.set_deferred("monitoring", true)
				$MageProjectile/MageHitcheck/Timer.wait_time = 1.8 - skills.AtkSpeed * 0.025
				$MageProjectile.speed = 220 * (1 + skills.AtkSpeed * 0.025)
				$MageProjectile.start()
			"archerattack":
				var arrowScene = load("res://player_arrow.tscn")
				var arrow = arrowScene.instantiate()
				arrow.global_position = global_position
				arrow.dir = Vector2.from_angle(get_angle_to(get_global_mouse_position()))
				add_child(arrow)
				await get_tree().create_timer(arrowcd).timeout
				attacked = false
			"knightattack":
				$KnightHitcheck.position = Vector2(12000.0, 12000.0)
				$KnightHitcheck.monitoring = true
				$KnightHitcheck.position = Vector2(0,0)
				$KnightHitcheck.rotate($KnightHitcheck.get_angle_to(get_global_mouse_position()) + 0.5*PI)
				$KnightHitcheck/AnimatedSprite2D.speed_scale = 1 + skills.AtkSpeed * 0.025
				$KnightHitcheck/AnimatedSprite2D.play("default")
#				$Soundcontroller/attack.pitch_scale = randf_range(0.6, 0.9)
#				$Soundcontroller.play(currentcharacter.Attack)
func applydamage() -> void:
	var damage = 0
	match currentcharacter.Class:
		"Assassin":
			$AssassinHitcheck.monitoring = false
		"Knight":
			$KnightHitcheck.monitoring = false
		"Mage":
			$MageProjectile/MageHitcheck.set_deferred("monitoring", false)
		#for equipment in equipped:
			#if equipment != null:
				#print(equipment)
	if currentcharacter.Class != "Mage":
		attacked = false
	
	for enemies in hitenemies:
		var validhit = RayCast2D.new()
		validhit.add_exception(self)
		validhit.enabled  = true
		validhit.hit_from_inside = true
		validhit.collision_mask = 1
		validhit.target_position = enemies.global_position - global_position
		add_child(validhit)
		validhit.force_raycast_update()
		if validhit.get_collider() == null or validhit.get_collider().name != "TileMapLayer" or currentcharacter.Class == "Mage":
			if get_node_or_null(get_path_to(enemies)) != null:
				match currentcharacter.Attack:
					"mageattack":
						damage = (currentcharacter.AttackDamage + arcadeStats.dmg) * (skills.MagicAtk + 10) / 10
					"daggerattack":
						damage = (currentcharacter.AttackDamage + arcadeStats.dmg) * (skills.PhysAtk + 10) / 10
					"archerattack":
						damage = (currentcharacter.AttackDamage + arcadeStats.dmg) * (skills.PhysAtk + 10) / 10
					"knightattack":
						damage = (currentcharacter.AttackDamage + arcadeStats.dmg) * (skills.PhysAtk + 10) / 10
				if randi_range(1,100) <= critchance:
					$AssassinHitcheck/AnimatedSprite2D.modulate = Color8(255,128,128)
					damage *= 1.5
				if (enemies.health - damage) <= 0.0:
					if (health + arcadeStats.lifesteal) < maxhealth- arcadeStats.lifesteal and arcadeStats.lifesteal != 0.0:
						health = maxhealth
					health += arcadeStats.lifesteal
				enemies.hit(damage)
			else:
				hitenemies.erase(enemies)
		validhit.queue_free()
	hitenemies.clear()
func hit(selfdamage, dodgeable = true, truedamage = false) ->void:
	var dodgerng = randi_range(0,100)
	if dodgerng <= dodgechance + arcadeStats.dodge_chance and dodgeable:
		$VFXController.play("dodge")
	else:
		if cantakedamage:
			if !truedamage:
				selfdamage = max(selfdamage - ((globalcharacterstats.BaseDefense + skills.Defense * 0.2)), 0.1)
			if health - selfdamage <= 0 and arcadeStats.laststand != 0.0:
				health = maxhealth + selfdamage
				arcadeStats.laststand = 0.0
				cantakedamage = false
				await get_tree().create_timer(arcadeStats.laststand).timeout
				cantakedamage = true
			else: 
				cantakedamage = false
				health -= selfdamage 
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
	if Input.is_action_just_pressed("1") and !attacked:
		switchcharacter(Characters[0])
	elif Input.is_action_just_pressed("2") and !attacked:
		switchcharacter(Characters[1])
	elif Input.is_action_just_pressed("3") and !attacked:
		switchcharacter(Characters[2])
	elif Input.is_action_just_pressed("4") and !attacked:
		switchcharacter(Characters[3])
		$KnightHitcheck.position = Vector2(12000.0, 12000.0) #ugly fix but it works, don't delete or knight attacks first hit may not register

func _physics_process(_delta: float) -> void:
	if global_position.distance_to(get_global_mouse_position()) > 120:
		$Camera2D.global_position = global_position + (get_local_mouse_position()/15)
	else:
		$Camera2D.global_position = global_position
	$RollCooldown/CanvasLayer/TextureProgressBar.max_value = $RollCooldown.wait_time * 100
	$RollCooldown/CanvasLayer/TextureProgressBar.value = ($RollCooldown.wait_time - $RollCooldown.time_left) * 100
	charactercheckchange()
	if health <= 0:
		death()
	else:
		for child in $Soundcontroller.get_children():
			child.volume_db = MenuMusic.setsfx()
		if !stunned:
			if health > maxhealth:
				health = maxhealth
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
			if Input.is_action_just_pressed("Roll"):
				roll()
			
			if Input.is_action_just_pressed("Ability"):
				if !usedability:
					ability()
		move_and_slide()



func _attack_animation_finished() -> void:
	$AssassinHitcheck/AnimatedSprite2D.modulate = Color8(255,255,255)
	applydamage()


func _on_hitcheck_area_entered(area: Area2D) -> void:
	hitenemies.append(area.get_parent())


func ability_timeout() -> void:
	usedability = false
	$GUI/Ability.visible = false


func ability_duration_timeout() -> void:
	$GUI/Ability/TextureProgressBar.modulate = Color(1,1,1)
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
	if abilityinuse and currentcharacter.Ability == "stun":
		area.get_parent().stun()


func _on_timer_timeout() -> void: #stun timer
	var stunSpriteTween = get_tree().create_tween()
	stunSpriteTween.set_parallel(false)
	$MageAbility/CollisionShape2D.set_deferred("disabled", true)
	stunSpriteTween.tween_property($MageAbility, "scale", Vector2(1,1), 0.1)
	stunSpriteTween.tween_property($MageAbility, "modulate", Color8(255,255,255,0), 0.1)


func _on_roll_cooldown_timeout() -> void:
	cantakedamage = true
	rolling = false


func _on_passive_health_regen_timeout() -> void:
	$GUI/VisionGlitch.visible = false
	if health > 0:
		health += regen


func _on_knightattack_finished() -> void:
	applydamage()


func _on_knight_hitcheck_area_entered(area: Area2D) -> void: #works fine, issue is somewher else
	if (area.get_parent().get_parent().name == "Enemies" or area.get_parent().get_parent().get_parent().name == "Enemies" or area.get_parent().name == "SpecialDummy") or area.get_parent().name.contains("Explosive Barrel") and currentcharacter.Class == "Knight":
		hitenemies.append(area.get_parent())
