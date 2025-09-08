extends CharacterBody2D


@export var stats = {
	"Health": 200,
	"Phase": 1,
	"isInvulnerable": false,
	"Activated": false #as in, has the player attacked it
}

#func _physics_process(_delta: float) -> void:
#	if position.distance_to()
	


func _on_fight_initiator_body_entered(body: Node2D) -> void:
	print(body)
