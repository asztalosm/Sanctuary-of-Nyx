extends Area2D
var inarea = false
@export var character = null
@export var damage = 5
@export var oncooldown = false
func _process(_delta: float) -> void:
	if character != null and character.cantakedamage and inarea and !oncooldown:
		character.hit(damage)
		oncooldown = true
		$ColorRect.color = Color8(220,80,80)
		var timer = get_tree().create_timer(1.0)
		await timer.timeout
		$ColorRect.color = Color8(255,0,0)
		oncooldown = false

func _on_body_entered(body: Node2D) -> void:
	character = body
	inarea = true

func _on_body_exited(_body: Node2D) -> void:
	character = null
	inarea = false
