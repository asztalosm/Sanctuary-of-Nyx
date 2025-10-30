extends Node2D
@export var coins = 0
func _process(_delta: float) -> void:
	$DungeonOverlay/RichTextLabel.text = " [imgresize=16]res://resources/coin.png[color=cfa951] " + str(coins)
	if get_node_or_null("Enemies/Knight") != null:
		pass
	else:
		$DungeonOverlay/Finish.visible = true
