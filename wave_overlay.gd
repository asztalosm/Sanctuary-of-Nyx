extends CanvasLayer
@export var spawnableEnemies = {}
@export var remainingEnemies = 0
@export var waveEnded = true
@export var playerStats = {}
@export var playerBuffs = {}

func set_values() -> void:
	print(playerBuffs)
	print(remainingEnemies)

func start_wave() -> void:
	print(remainingEnemies)
	visible = true
