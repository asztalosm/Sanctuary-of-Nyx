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
var attacklist = ["slashattack", "alldirattack"] #will probably make two of these when i start making the second phase
var attacked = false

func finishedattack():
	$SwordHitbox/AnimatedSprite2D.play("RESET")
	for children in $AllDirHitbox.get_children():
		children.get_node("AnimatedSprite2D").play("RESET")
	$AttackCooldown.start()

func slashAttack():
	$SwordHitbox.rotation = self.get_angle_to(player.global_position) - deg_to_rad(90)
	$SwordHitbox/AnimatedSprite2D.play("default")
	await $SwordHitbox/AnimatedSprite2D.animation_finished
	var swordMovementTween = get_tree().create_tween()
	swordMovementTween.set_parallel(false)
	swordMovementTween.tween_property($SwordHitbox, "global_position", global_position + Vector2.from_angle(get_angle_to(player.global_position)) * 300, 1.5)
	swordMovementTween.tween_property($SwordHitbox, "global_position", global_position, 0)
	await swordMovementTween.finished
	finishedattack()

func alldirAttack():
	for hitboxes in $AllDirHitbox.get_children():
		hitboxes.get_node("AnimatedSprite2D").play("default")
	await $AllDirHitbox/CollisionPolygon2D4/AnimatedSprite2D.animation_finished
	var multiSwordTween = get_tree().create_tween()
	multiSwordTween.set_parallel(true)
	for hitboxes in $AllDirHitbox.get_children():
		multiSwordTween.tween_property(hitboxes, "position", hitboxes.position * 5, 1.5)
	await multiSwordTween.finished
	for hitboxes in $AllDirHitbox.get_children():
		multiSwordTween.stop()
		multiSwordTween.tween_property(hitboxes, "position", hitboxes.position / 5, 0)
		multiSwordTween.play()
	finishedattack()


func death() -> void:
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
		"alldirattack":
			damage = 3
			dodgeable = false
			truedamage = true
			alldirAttack()

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

func _on_attack_cooldown_timeout() -> void:
	attacked = false


func _on_all_dir_hitbox_body_entered(body: Node2D) -> void:
	print(body)
	body.hit(damage, dodgeable, truedamage)
