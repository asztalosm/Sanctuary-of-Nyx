extends CanvasLayer
@export var isIntermission = false
@export var dicenumber = 0
@export var rerollpoints = 5
var wavecount = 1
var diceAtlas = AtlasTexture.new()
var dicerolling = false
var dices = []
var currentdice = null
var enemyList = { #so these will be decided whether theyll spawn in the setDescription function along with a count of enemies
	"Assassin": range(1,6),
	"Archer": range(1,5),
	"Necromancer": range(1,4),
	"Skeleton": range(1,6),
	"Splasher": range(1,3)
}
var enemyBuffList = {
	"hp": range(1,6),
	"damage": range(1,6),
	"speed": range(1,5), 
	"attackcooldown": range(-1,-3),
	"range": range(1,2)}
var playerStatsList = {"hp": range(1,6),
	"dmg": range(1,6),
	"dodge chance": range(1,4),
	"mov spd": range(1,3),
	"crit chance": range(1,2),
	"def": range(1,6)}
var playerBuffList = ["Skill points every wave start", "more XP per kill", "Life Steal", "Last Stand", "Point Multiplier"]
@onready var WaveOverlay = get_parent().get_node("WaveOverlay")

func intermission() -> void: #makes the intermission visible
	if isIntermission:
		get_tree().paused = false
		visible = false
		isIntermission = false
	else:
		get_tree().paused = true
		isIntermission = true
		visible = true

func startwave() -> void: #starts the wave
	WaveOverlay.set_values()
	await get_tree().create_timer(5).timeout
	WaveOverlay.start_wave()
	get_parent().get_node("EnemySpawners")._activateSpawner()

func endwave() -> void:
	wavecount += 1
	$Waves.text = "Waves: " + str(wavecount)
	intermission()
	for dice in $Dice.get_children():
		currentdice = dice
		dices.append(dice)
		dice.texture_normal = AtlasTexture.new() #we have to reference texture_normal to edit this, it's uglier than a variable but easier for me
		dice.texture_normal.atlas = load("res://resources/dice.png")
		dice.texture_normal.region.size = Vector2(32,32)
		dicenumber = randi_range(1,6)
		dice.texture_normal.region.position = Vector2(32 * dicenumber, 0)
		setDescription()

func _animate_roll(dice) -> void: #starts the dice animation, a signal will end this and get the value
	if rerollpoints > 0:
		$Dicesound.play()
		rerollpoints -= 1
		dicerolling = true
		currentdice = dice
		dice.get_node("AnimationTimer").start()
		dice.get_node("Timer").start()


func setDescription() -> void: #sets the description and stats for the 4 dices and passes value to the waveoverlay so that it can make the gamemode work
	var description = ""
	
	#values to be passed to the waveoverlay and the arcade script of the character
	var characterBuff = {
		"Type": "",
		"Value": 0.0
	}
	
	
	match currentdice.name:
		"EnemyStats":
			
			for stat in enemyBuffList:
				var enemyRolls = enemyBuffList[stat]
				var randomnum = randi_range(1,6) #decides if the debuff/buff will exist or not
				var buffscale = snapped(randf_range(0.1,0.8) * ((6-dicenumber+1)), 0.1) #the float that decides what gets buffed and by how much
				if randomnum in enemyRolls:
					description += "[color=#881111]+" + str(snapped(buffscale, 0.1)) + "[/color]"  + str(stat) +"\n"
					get_parent().get_node("EnemySpawners").enemyStats.get_or_add(stat, buffscale)
			currentdice.get_node("RichTextLabel").get_node("RichTextLabel").text = description

		"EnemyCount": #sends count to WaveOverlay
			WaveOverlay.spawnableEnemies.clear()
			for enemies in enemyList:
				var enemyRolls = enemyList[enemies]
				var randomnum = randi_range(1,6)
				var randomcount = randi_range(1,10) * (6-dicenumber+1)
				if randomnum in enemyRolls:
					description += "[color=#881111]" + str(randomcount) + "[/color] " + str(enemies) +"\n"
					WaveOverlay.spawnableEnemies.get_or_add(enemies, randomcount)
			if description == "": #failsafe enemy spawns, others don't need failsafe
				description = "[color=#881111]15[/color] Assassin\n[color=#881111]14[/color] Archer\n[color=#881111]3[/color] Necromancer\n[color=#881111]8[/color] Skeleton\n"
			currentdice.get_node("RichTextLabel").get_node("RichTextLabel").text = description

		"CharacterStats": #sends stats to WaveOverlay
			for statkeys in playerStatsList:
				var stat = playerStatsList[statkeys]
				var randomnum = randi_range(1,6)
				var statscale = snapped(randf_range(0.1, 0.4) * dicenumber, 0.1)
				if int(randomnum) in stat:
					description += "[color=#118811]+"+ str(statscale) + "[/color] " + str(statkeys) +"\n"
					WaveOverlay.playerStats.get_or_add(statkeys, statscale)
			currentdice.get_node("RichTextLabel").get_node("RichTextLabel").text = description

		"CharacterBuffs": #sends buff to WaveOverlay
			var buff = playerBuffList[randi_range(0,len(playerBuffList)-1)]
			var buffvalue = 0.0
			if buff == playerBuffList[0]:
				var wavestartSP = 1
				if dicenumber == 1:
					wavestartSP = 1
				else:
					wavestartSP = roundi(int(dicenumber/2)) # integer division error but it's ignored
				buffvalue = wavestartSP
				description += "[color=#118811]+" + str(wavestartSP) + "[/color] "

			if buff == playerBuffList[1]:
				var extraxp = float(randi_range(1,10) * dicenumber)
				description += "[color=#118811]+ " + str(extraxp) + "[/color] "
				buffvalue = extraxp

			if buff == playerBuffList[2]:
				var healthperkill = snapped((randf_range(0.1,0.5) * dicenumber), 0.1)
				description += "[color=#118811]+ " + str(healthperkill)+ "hp/kill[/color] "
				buffvalue = healthperkill

			if buff == playerBuffList[3]:
				var length = snapped((randf_range(0.3,0.5) * dicenumber), 0.1)
				description += "[color=#118811]" + str(length) + "s[/color] - heal back to half health before death, usable once per run - "
				buffvalue = length

			if buff == playerBuffList[4]:
				var multiplier = snapped(randf_range(1.3, 1.5), 0.1) * float((10+dicenumber) / 10)
				description = "[color=#118811]" + str(multiplier) + "x[/color] "
				buffvalue = multiplier

			description += buff
			characterBuff.Type = buff
			characterBuff.Value = buffvalue
			WaveOverlay.playerBuffs = characterBuff
			currentdice.get_node("RichTextLabel").get_node("RichTextLabel").text = description

func _ready() -> void:
	intermission()
	for dice in $Dice.get_children():
		currentdice = dice
		dices.append(dice)
		dice.texture_normal = AtlasTexture.new() #we have to reference texture_normal to edit this, it's uglier than a variable but easier for me
		dice.texture_normal.atlas = load("res://resources/dice.png")
		dice.texture_normal.region.size = Vector2(32,32)
		dicenumber = randi_range(1,6)
		dice.texture_normal.region.position = Vector2(32 * dicenumber	, 0)
		setDescription()

func _process(_delta: float) -> void:
	$RichTextLabel3.text = "rerolls: " + str(rerollpoints)


func _on_animation_timer_timeout() -> void:
	dicenumber = randi_range(1,6)
	currentdice.texture_normal.region.position = Vector2(32 * dicenumber ,0)


func _on_timer_timeout() -> void:
	currentdice.get_node("AnimationTimer").stop()
	dicerolling = false
	setDescription()


func _on_enemy_stats_pressed() -> void: #just some ugly signals, ignore
	if !dicerolling:
		_animate_roll(dices[0])
func _on_enemy_count_pressed() -> void:
	if !dicerolling:
		_animate_roll(dices[1])
func _on_character_stats_pressed() -> void:
	if !dicerolling:
		_animate_roll(dices[2])
func _on_character_buffs_pressed() -> void:
	if !dicerolling:
		_animate_roll(dices[3])
func _on_button_pressed() -> void: #this is the play button
	if !dicerolling:
		intermission()
		startwave()
