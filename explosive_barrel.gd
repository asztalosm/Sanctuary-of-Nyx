extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "MageProjectile" and body.moving:
		$AnimatedSprite2D.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$Area2D.scale = Vector2(4,4)
	$Area2D/GPUParticles2D.restart()
	$AnimatedSprite2D.play("Explosion")
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		area.get_parent().hit(5, false)
	else:
		area.get_parent().health -= 3.0
		
