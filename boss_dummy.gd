extends CharacterBody2D
@export var maxhealth = 200
@export var health = maxhealth / 8.0
var bossbar = null
@export var stats = {
	"Phase": 1,
	"isInvulnerable": false,
	"Activated": false, #as in, has the player attacked it / went near it
	"Name": "Knight",
}

func death() -> void:
	print("drop loot, write whats dropped, play death animation, give loads of xp")
	bossbar.visible = false
	queue_free()


func _physics_process(_delta: float) -> void:
	refreshgui()
	if health <= 0:
		death()


func refreshgui() -> void:
	if bossbar != null:
		bossbar.get_node("BossHealth").value = health
		bossbar.get_node("BossName").text = stats.Name
		bossbar.get_node("BossHealth").max_value = maxhealth
	else:
		return


func _on_fight_initiator_body_entered(body: Node2D) -> void:
	if stats.Activated == false:
		stats.Activated = true
		bossbar = body.get_node("GUI").get_node("BossBar")
		bossbar.visible = true
		
