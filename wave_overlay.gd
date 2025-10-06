extends CanvasLayer
@export var spawnableEnemies = {}
@export var remainingEnemies = 0 #will be calculated in the _process function and updates gui
@export var waveEnded = true
@export var playerStats = {} #
@export var playerBuffs = {}
@export var enemyStats = {}
@onready var points = get_parent().get_node("Character").get_node("Player").points

#var playerStatsList = {"hp": range(1,6),
#	"dmg": range(1,6),
#	"dodge chance": range(1,4),
#	"mov spd": range(1,3),
#	"crit chance": range(1,2),
#	"def": range(1,6)}S

# "Skill points every wave start"
# "more XP per kill"
# "Life Steal"
# "Last Stand"
# "Point Multiplier"]

func set_values() -> void:
	var sum = 0
	for i in spawnableEnemies.values():
		sum += i
	remainingEnemies = sum
	if playerBuffs.find_key("Point Multiplier"):
		playerStats.get_or_add("Point Multiplier", playerBuffs.get("Value"))
	if playerBuffs.find_key("more XP per kill"):
		playerStats.get_or_add("more XP per kill", playerBuffs.get("Value"))
	if playerBuffs.find_key("Life Steal"):
		playerStats.get_or_add("lifesteal", playerBuffs.get("Value"))
	for stats in get_parent().get_node("Character").get_node("Player").arcadeStats:
		for stats_to_set in playerStats:
			if stats_to_set == stats:
				get_parent().get_node("Character").get_node("Player").arcadeStats.set(stats, playerStats.get(stats_to_set))


func start_wave() -> void:
	$WaveEnd.visible = false
	visible = true
	get_parent().get_node("Character").get_node("Player").arcadeStats.set("laststand", playerBuffs.get("Value"))


func _process(_delta: float) -> void:
	set_values()
	points = get_parent().get_node("Character").get_node("Player").points
	$Points.text = "Points: " + str(points)
	$Enemies.text = "Spawns left: [color=#881111]" + str(remainingEnemies) + "[/color]"
