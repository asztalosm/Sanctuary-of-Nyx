extends Node2D
@export var activatedspawner : Marker2D
var waveended = false
@export var enemyStats = {}

func _activateSpawner():
	$ChangeSpawner.start()
	activatedspawner = $Markers.get_node("Spawner"+str(randi_range(1,8)))
	activatedspawner.get_node("Sprite2D").visible = true
	$SpawnTimer.start()
	waveended = false

func changeSpawner() -> void:
	if !waveended:
		activatedspawner.get_node("Sprite2D").visible = false
		activatedspawner = $Markers.get_node("Spawner"+str(randi_range(1,8)))
		activatedspawner.get_node("Sprite2D").visible = true

func _ready() -> void:
	for spawners in $Markers.get_children():
		if spawners.name == "Timer":
			return
		else:
			spawners.get_node("Sprite2D").visible = false


func _on_timer_timeout() -> void:
	changeSpawner()

func addstat(enemy) -> void:
	for stats in enemyStats:
			if stats == "range":
				#enemy.set(stats, (enemy.get(stats) + enemyStats.get(stats)))
				enemy.get_node("Detection").scale *= enemyStats.get(stats)
			elif stats == "hp":
				enemy.set("maxhealth", enemy.maxhealth + enemyStats.get(stats))
				enemy.set("health", enemy.health + enemyStats.get(stats))
			else:
				return #fuckall

func _on_spawn_timer_timeout() -> void:
	if !waveended:
		var randomEnemy = []
		var spawnableEnemies = get_parent().get_node("WaveOverlay").spawnableEnemies
		for keys in spawnableEnemies:
			randomEnemy.append(keys)
		if (len(randomEnemy) > 0):
			var selectedEnemy = randi_range(0, len(randomEnemy)-1)
			var enemyName = randomEnemy[selectedEnemy] #this is what we use as the key in the dictionary
			spawnableEnemies.set(enemyName, spawnableEnemies.get(enemyName)-1)
			if spawnableEnemies.get(enemyName) == 0:
				spawnableEnemies.erase(enemyName)
			match enemyName:
				"Assassin":
					var assassin = preload("res://enemy_dummy.tscn")
					var enemy = assassin.instantiate()
					get_parent().get_node("Enemies").add_child(enemy)
					addstat(enemy)
					enemy.global_position = activatedspawner.global_position
				"Necromancer":
					var necromancer = preload("res://necromancer_enemy.tscn")
					var enemy = necromancer.instantiate()
					get_parent().get_node("Enemies").add_child(enemy)
					addstat(enemy)
					enemy.global_position = activatedspawner.global_position
				"Skeleton":
					var skeleton = preload("res://skeleton_summon.tscn")
					var enemy = skeleton.instantiate()
					get_parent().get_node("Enemies").add_child(enemy)
					addstat(enemy)
					enemy.global_position = activatedspawner.global_position
				"Archer":
					var archer = preload("res://archer_enemy.tscn")
					var enemy = archer.instantiate()
					get_parent().get_node("Enemies").add_child(enemy)
					addstat(enemy)
					enemy.global_position = activatedspawner.global_position
				"Splasher":
					var splasher = preload("res://splasher.tscn")
					var enemy = splasher.instantiate()
					get_parent().get_node("Enemies").add_child(enemy)
					addstat(enemy)
					enemy.global_position = activatedspawner.global_position
		elif (len(randomEnemy) == 0) and get_parent().get_node("Enemies").get_child_count() == 0 and !waveended:
			waveended = true
			get_parent().get_node("WaveOverlay").get_node("WaveEnd").text = "Wave " + str(get_parent().get_node("Intermission").wavecount) + " completed."
			get_parent().get_node("WaveOverlay").get_node("WaveEnd").visible = true
			await get_tree().create_timer(3.0).timeout
			get_parent().get_node("Intermission").endwave()
			activatedspawner = null
			for spawners in $Markers.get_children():
				if spawners.name == "Timer":
					return
				else:
					spawners.get_node("Sprite2D").visible = false
