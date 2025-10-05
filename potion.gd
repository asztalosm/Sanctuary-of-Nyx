extends Area2D
var brokenposition = null
@onready var targetposition = get_parent().target.global_position
var airtime = 3.0 #seconds
@onready var movetween = get_tree().create_tween()
var broken = false
func breakpotion() -> void:
	broken = true
	$CollisionShape2D.set_deferred("disabled", true)
	print("will summon the lingering effect later, now i just want to make this work because 3 am tiredness")
	$GPUParticles2D.restart()
	$Sprite2D.visible = false
	movetween.stop()
	brokenposition = global_position
	

func _ready() -> void:
	top_level = true
	var relativedistance = targetposition - global_position
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


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
