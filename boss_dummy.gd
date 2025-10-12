extends CharacterBody2D
@export var maxhealth = 200
@export var health = maxhealth / 8.0
var bossbar = null
var player = null
@export var stats = {
	"Phase": 1,
	"isInvulnerable": false,
	"Activated": false, #as in, has the player attacked it / went near it
	"Name": "Knight",
}
var damage
var dodgeable
var truedamage
var attacklist = ["slashattack"] #will probably make two of these when i start making the second phase
var attacked = false


func slashAttack():
	$SwordHitbox/AnimatedSprite2D.play("default")
	var swordMovementTween = get_tree().create_tween()
	swordMovementTween.set_parallel(false)
	swordMovementTween.tween_property($SwordHitbox, "global_position", player.global_position, 1.5)
	swordMovementTween.tween_property($SwordHitbox, "global_position", global_position, 0)

func death() -> void:
	print("drop loot, write whats dropped, play death animation, give loads of xp")
	player.globalcharacterstats.Xp += 2000
	bossbar.visible = false
	queue_free()

func rollAttack():
	attacked = true
	match attacklist[randi_range(0, len(attacklist)-1)]:
		"slashattack":
			damage = 3
			dodgeable = false
			truedamage = true
			slashAttack()

func _physics_process(_delta: float) -> void:
	refreshgui()
	if health <= 0:
		death()
	if !attacked and player != null:
		rollAttack()


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
		player = body
		bossbar = body.get_node("GUI").get_node("BossBar")
		bossbar.visible = true


func _on_sword_hitbox_body_entered(body: Node2D) -> void:
	body.hit(damage, dodgeable, truedamage)


func _on_animated_sprite_2d_animation_finished() -> void:
	$SwordHitbox/AnimatedSprite2D.play("RESET") #might add exclusions later
