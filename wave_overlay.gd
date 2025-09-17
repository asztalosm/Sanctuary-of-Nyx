extends CanvasLayer
@export var spawnableEnemies = {}
@export var remainingEnemies = {}
var spawnedEnemies 

func _start_wave() -> void:
	print(spawnableEnemies)
