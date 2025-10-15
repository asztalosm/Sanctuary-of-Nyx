extends CharacterBody2D
@export var dir = Vector2(0,0)
@export var speed = 100

func _ready() -> void:
	rotation = self.get_angle_to(get_parent().target.global_position) + deg_to_rad(90)
	$Area2D/CollisionShape2D2/AnimatedSprite2D.play(str(randi_range(1,4)))
	$Area2D/CollisionShape2D3/AnimatedSprite2D.play(str(randi_range(1,4)))
	$Area2D/CollisionShape2D4/AnimatedSprite2D.play(str(randi_range(1,4)))
	await get_tree().create_timer(3).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	velocity = dir * speed
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().cantakedamage:
		area.get_parent().hit(2.5)
		area.get_parent().get_node("GUI").get_node("VisionGlitch").visible = true
	queue_free()
