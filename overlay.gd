extends CanvasLayer
var szovegek = [
	"",
	"Welcome to Sanctuary of Nyx!", #1
	"Sanctuary of Nyx is a souls-like game that will have an open world and will be very RPG-like. Currently there is only an arcade gamemode. And the assets are just placeholders", #2
	"You can move your character around with WASD or the arrow keys", #3
	"You have the ability to control multiple characters, check them out by pressing the numbers on your keyboard.", #4
	"Follow The arrows and meet a dummy enemy to learn how the attacks work"
]
var counter = 1
var utolsoelotti = len(szovegek)-1
var canprogress = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Label.visible:
		if Input.is_action_just_pressed("E") and canprogress:
			match (counter):
				3:
					print("characterchange")
					counter += 1
					canprogress = false
				utolsoelotti:
					print("utolsón továbblépett")
					$Label.visible = false
				_:
					counter += 1
					canprogress = true
		$Label.text = szovegek[counter]
	if Input.is_action_just_pressed("1") or Input.is_action_just_pressed("2") or Input.is_action_just_pressed("3") or Input.is_action_just_pressed("4") or Input.is_action_just_pressed("5") or Input.is_action_just_pressed("6") and counter == 2 and !canprogress:
		canprogress = true
		
