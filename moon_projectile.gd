extends Area2D
@export var damage = 3.0


func _ready() -> void:
	collision_mask = 0
	$CollisionShape2D.visible = false
	await get_tree().create_timer(0.5).timeout
	var collisiontween = get_tree().create_tween()
	$CollisionShape2D.visible = true
	collisiontween.tween_property($CollisionShape2D, "position", Vector2(0,0), 0.8)
	await collisiontween.finished
	collision_mask = 4
	#await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.scale = Vector2(1.2,1.2)
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.get_parent().name == "Enemies":
		body.hit(damage)
