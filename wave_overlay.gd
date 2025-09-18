extends CanvasLayer
@export var spawnableEnemies = {}
@export var remainingEnemies = 0 #will be calculated in the _process function and updates gui
@export var waveEnded = true
@export var playerStats = {}
@export var playerBuffs = {}
@export var enemyStats = {}

func set_values() -> void:
	print("Player buffs: ", playerBuffs)
	print("Spawnable enemies: ", spawnableEnemies)
	var sum = 0
	for i in spawnableEnemies.values():
		sum += i
	remainingEnemies = sum
	print("Remaining enemies: ", remainingEnemies)
	print("Player stats: ", playerStats)
	print("Enemy stats: ", enemyStats)

func start_wave() -> void:
	print("Spawnable enemies:")
	print(remainingEnemies)
	visible = true
