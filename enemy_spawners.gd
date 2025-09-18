extends Node2D
@export var activatedspawner : Marker2D

func _activateSpawner(spawner):
	print(spawner)



func _ready() -> void:
	for spawners in get_children():
		spawners.get_node("Sprite2D").visible = false
