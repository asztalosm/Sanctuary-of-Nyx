extends CharacterBody2D
@export var dir = Vector2(0,0)
@export var speed = 250
func _ready() -> void:
	rotation = self.get_angle_to(get_global_mouse_position()) - deg_to_rad(90)
	velocity = dir * speed
	await get_tree().create_timer(0.1).timeout
	collision_mask = 1
	await get_tree().create_timer(3.0).timeout
	queue_free()
	
func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.get_parent().name)
	if area.get_parent().get_parent().name == "Enemies" or area.get_parent().name.contains("Explosive Barrel") or area.get_parent().get_parent().get_parent().name == "Enemies":
		area.get_parent().hit(3.0)
		queue_free()

func _on_wallcheck_body_entered(body: Node2D) -> void:
	if body.get_parent().get_parent().name != "Enemies" and body.name != "Player":
		velocity = Vector2(0,0)
		speed = 0
		collision_mask = 0
		await get_tree().create_timer(0.3).timeout
		queue_free()
