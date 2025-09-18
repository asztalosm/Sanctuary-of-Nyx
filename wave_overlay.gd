extends CanvasLayer
@export var spawnableEnemies = {}
@export var remainingEnemies = 0 #will be calculated in the _process function and updates gui
@export var waveEnded = true
@export var playerStats = {}
@export var playerBuffs = {}
@export var enemyStats = {}
@export var points = 0

func set_values() -> void:
	var sum = 0
	for i in spawnableEnemies.values():
		sum += i
	remainingEnemies = sum

func start_wave() -> void:
	visible = true


func _process(_delta: float) -> void:
	$Points.text = "Points: " + str(points)
