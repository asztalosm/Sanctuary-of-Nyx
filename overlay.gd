extends CanvasLayer
var texts = [
	"",
	"Welcome to Sanctuary of Nyx!", #1
	"Sanctuary of Nyx is a souls-like game that will have an open world and will be very RPG-like. Currently there is only an arcade gamemode. And the assets are just placeholders", #2
	"You can move your character around with WASD or the arrow keys", #3
	"You have the ability to control multiple characters, check them out by pressing the numbers on your keyboard.", #4
	"Follow The arrows and meet a dummy enemy to learn how the attacks work.", #5
	"You can attack by pressing the left mouse click, each character has unique attacks that make them viable in different situations. Kill the dummy", #6
	"When you kill an enemy you gain experience.", #7
	"From killing the dummy you got a skill point, you can spend them by pressing R.", #8
	"As you could see, hovering over the skills gave you a detailed explanation on how that given skill works.", #9
	"These will be very important during your gameplay, but the difference is only noticable when they are upgraded a lot.", #10
	"Your characters also have a special ability, which you can use by pressing the right mouse button. Lets go over what each of them do.", #11
	"1. Assassin: You turn invisible to enemies and your movement speed is increased. Great for escaping risky situations.", #12
	"2. Mage: You send out a shockwave that stuns enemies, who won't be able to move for 4 seconds, which gives you enough time to change characters and attack them.", #13
	"3. Archer: You shoot out 5 arrows very quickly, high DPS, but i will nerf it so enjoy it while you can (oo 4th wall break).", #14
	"4. Knight: You take less damage from enemies, in return you will be very slow.", #15
	"You will have to use these abilities to get through the next section, but you will have to figure that out on your own.", #16
	"There are multiple ways to achieve your goal, try as many characters as you can.", #17
	"Now that you are familiar with the attacks and the abilities, progress to the next part to fight enemies, but before that some info about them.", #18
	"There are 3 types of enemies, you will meet 2 of them here, as the third type isn't finished yet.", #19
	"1. Simple/Default: The kind of enemies that shouldn't pose a big problem, they have 1 type of attack and very simple AI", #20
	"2. Advanced/Elite 1/3: Enemies that have more advanced attacks, and will use the best attack for each situation (in the future, not implemented yet).", #21
	"2. Advanced/Elite 2/3: They also have increased health and DPS and will alert more enemies and 'request' help from them. Fighting elite and simple enemies at the same time might cause issues.", #22
	"2. Advanced/Elite 3/3: You can differentiate them from normal enemies by their hitbox.", #23
	"3. Bosses: The hardest enemies of them all, multiple stages, barrage of attacks that are hard to dodge. These are the most WIP of them all. But in the future i hope to give them item drops.", #24
	"Now that you know the enemy types, let's fight some of them!", #24
	"The last piece of information about the game is that campfires act as save points. Though these will only be used in the campaign which isn't released yet.", #25
	"You have finished the tutorial, to exit the tutorial interact with the campfire at the end or press the P/ESCAPE button" #26
]

var counter = 1
var utolsoelotti = len(texts)-2
var utolso = len(texts)-1
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
				#execution isn't that nice but whatever
				3:
					cantProgress()
				4: #deletes the wall which has the dummy behind it
					get_parent().get_node("Collisions").get_node("StaticBody2D2").queue_free()
					counter += 1
				5: #kill dummy
					cantProgress() 
				7: #open skills menu
					cantProgress()
				15:
					counter += 1
					get_parent().get_node("Collisions").get_node("StaticBody2D3").queue_free()
					cantProgress()
				23:
					counter += 1
					get_parent().get_node("Collisions").get_node("StaticBody2D5").queue_free()
					cantProgress()
				utolsoelotti:
					canProgress()
					$Label/RichTextLabel.text = "Press E to exit"
					counter += 1
				utolso:
					$Label.visible = false
				_:
					counter += 1
					canprogress = true
		$Label.text = texts[counter]
	if (Input.is_action_just_pressed("1") or Input.is_action_just_pressed("2") or Input.is_action_just_pressed("3") or Input.is_action_just_pressed("4") or Input.is_action_just_pressed("5") or Input.is_action_just_pressed("6")) and counter == 4 and !canprogress:
		canProgress()
	if Input.is_action_just_pressed("Skills") and counter == 8:
		canProgress()
