extends CharacterBody2D
@export var dir = Vector2(0,0)
@export var speed = 200
@export var damage = 1.0
#@export var arrowmodel = texture here
func _ready() -> void:
	rotation = self.get_angle_to(get_parent().target.global_position) + deg_to_rad(90)
	await get_tree().create_timer(3).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	velocity = dir * speed
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().cantakedamage:
		area.get_parent().hit(damage)
	queue_free()
