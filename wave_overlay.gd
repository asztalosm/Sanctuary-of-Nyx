extends CanvasLayer
@export var spawnableEnemies = {}
@export var remainingEnemies = 0 #will be calculated in the _process function and updates gui
@export var waveEnded = true
@export var playerStats = {} #
@export var playerBuffs = {}
@export var enemyStats = {}
@export var points = 0

#var playerStatsList = {"hp": range(1,6),
#	"dmg": range(1,6),
#	"dodge chance": range(1,4),
#	"mov spd": range(1,3),
#	"crit chance": range(1,2),
#	"def": range(1,6)}


func set_values() -> void:
	var sum = 0
	for i in spawnableEnemies.values():
		sum += i
	remainingEnemies = sum

func start_wave() -> void:
	visible = true


func _process(_delta: float) -> void:
	set_values()
	$Points.text = "Points: " + str(points)
	$Enemies.text = "Spawns left: [color=#881111]" + str(remainingEnemies) + "[/color]"
