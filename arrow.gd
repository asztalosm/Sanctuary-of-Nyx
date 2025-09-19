extends CharacterBody2D
@export var dir = Vector2(0,0)
@export var speed = 120
#@export var arrowmodel = texture here

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	self.get_angle_to(get_parent().target.global_position)
	$ColorRect.rotation = self.get_angle_to(get_parent().target.global_position) #ill fix rotation later, lets just push this update
	queue_free()

func _physics_process(_delta: float) -> void:
	velocity = dir * speed + Vector2(randi_range(-30,30), randi_range(-30,30))
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().health -= get_parent().damage
	queue_free()
