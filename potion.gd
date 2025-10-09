extends Area2D
var brokenposition = null
@export var targetposition = Vector2.ZERO
var airtime = 3.0 #seconds
@onready var movetween = get_tree().create_tween()
var broken = false
var character = null

func linger() -> void:
	$Linger.visible = true
	$Linger/Sprite2D.scale = Vector2(0.05, 0.05)
	$Linger/Sprite2D.modulate = Color8(255,255,255,50)
	var spriteTween = get_tree().create_tween()
	spriteTween.tween_property($Linger/Sprite2D, "scale", Vector2(1, 1), 0.5)
	spriteTween.tween_property($Linger/Sprite2D, "modulate", Color8(255,255,255,160), 0.1)
	spriteTween.tween_property($Linger/Sprite2D, "modulate", Color8(255,255,255,0), 2)
	$Linger/Timer.start()

func breakpotion() -> void:
	broken = true
	$CollisionShape2D.set_deferred("disabled", true)
	linger()
	$GPUParticles2D.restart()
	$Sprite2D.visible = false
	movetween.stop()
	brokenposition = global_position
	$Linger/Area2D/CollisionShape2D.set_deferred("disabled", false)
	

func _ready() -> void:
	top_level = true
	if targetposition != Vector2.ZERO:
		movetween.set_parallel(false)
		movetween.tween_property(self, "global_position", targetposition, airtime / 2)


func _process(_delta) -> void:
	if brokenposition != null:
		global_position = brokenposition
	if global_position == targetposition and !broken:
		breakpotion()

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().hit(3)
	breakpotion()

	


func _on_timer_timeout() -> void:
	queue_free()




func _on_area_2d_area_entered(area: Area2D) -> void:
	character = area.get_parent()
	$Linger/AttackTimer.start()


func _on_attack_timer_timeout() -> void:
	if character != null:
		character.hit(1, false)


func _on_area_2d_area_exited(_area: Area2D) -> void:
	character = null
