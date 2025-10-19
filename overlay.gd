extends CanvasLayer
var szovegek = [
	"",
	"Welcome to Sanctuary of Nyx!", #1
	"Sanctuary of Nyx is a souls-like game that will have an open world and will be very RPG-like. Currently there is only an arcade gamemode. And the assets are just placeholders", #2
	"You can move your character around with WASD or the arrow keys", #3
	"You have the ability to control multiple characters, check them out by pressing the numbers on your keyboard.", #4
	"Follow The arrows and meet a dummy enemy to learn how the attacks work.", #5
	"You can attack by pressing the left mouse click, each character has unique attacks that make them viable in different situations.",
	"When you kill an enemy you gain experience.", #6
	"From killing the dummy you got a skill point, you can spend them by pressing R.", #7
	"As you could see, hovering over the skills gave you a detailed explanation on how that given skill works.", #8
	"These will be very important during your gameplay, but the difference is only noticable when they are upgraded a lot.", #9
	"Your characters also have a special ability, which you can use by pressing the right mouse button. Lets go over what each of them do.", #10
	"1. Assassin: You turn invisible to enemies and your movement speed is increased. Great for escaping risky situations.", #11
	"2. Mage: You send out a shockwave that stuns enemies, who won't be able to move for 4 seconds, which gives you enough time to change characters and attack them.", #12
	"3. Archer: You shoot out 5 arrows very quickly, high DPS, but i will nerf it so enjoy it while you can (oo 4th wall break).", #13
	"4. Knight: You take less damage from enemies, in return you will be very slow.",
	"WIP: you will have to use these abilities"
	
	
]
var counter = 1
var utolsoelotti = len(szovegek)-2
var utolso = len(szovegek)-1
var canprogress = true
func cantProgress() -> void:
	canprogress = false
	$Label/RichTextLabel.text = "Finish objective before progressing"
	counter += 1

func canProgress() -> void:
	canprogress = true
	$Label/RichTextLabel.text = "Press E to continue"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Label.visible:
		if Input.is_action_just_pressed("E") and canprogress:
			match (counter):
				3:
					cantProgress()
				4:
					get_parent().get_node("Collisions").get_node("StaticBody2D2").queue_free()
					counter += 1
				5:
					cantProgress()
				7:
					cantProgress()
				utolsoelotti:
					$Label/RichTextLabel.text = "Press E to exit"
					counter += 1
				utolso:
					$Label.visible = false
				_:
					counter += 1
					canprogress = true
		$Label.text = szovegek[counter]
	if (Input.is_action_just_pressed("1") or Input.is_action_just_pressed("2") or Input.is_action_just_pressed("3") or Input.is_action_just_pressed("4") or Input.is_action_just_pressed("5") or Input.is_action_just_pressed("6")) and counter == 4 and !canprogress:
		canProgress()
	if Input.is_action_just_pressed("Skills") and counter == 8:
		canProgress()
