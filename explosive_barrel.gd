extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "MageProjectile":
		$AnimatedSprite2D.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$Area2D.scale = Vector2(4,4)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	
