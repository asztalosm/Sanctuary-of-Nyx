extends CharacterBody2D
@export var dir = Vector2(0,0)
@export var speed = 250
func _ready() -> void:
	rotation = self.get_angle_to(get_global_mouse_position()) + deg_to_rad(90) #ill fix rotation later, lets just push this update
	velocity = dir * speed
	await get_tree().create_timer(3.0).timeout
	queue_free()
	
func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().health -= 3.0
	area.get_parent().get_node("AnimationPlayer").play("hit")
	queue_free()
