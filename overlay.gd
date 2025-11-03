extends CanvasLayer
var texts = [
	"",
	tr("TUTORIAL_1"),
	tr("TUTORIAL_2"),
	tr("TUTORIAL_3"),
	tr("TUTORIAL_4"),
	tr("TUTORIAL_5"),
	tr("TUTORIAL_6"),
	tr("TUTORIAL_7"),
	tr("TUTORIAL_8"),
	tr("TUTORIAL_9"),
	tr("TUTORIAL_10"),
	tr("TUTORIAL_11"),
	tr("TUTORIAL_12"),
	tr("TUTORIAL_13"),
	tr("TUTORIAL_14"),
	tr("TUTORIAL_15"),
	tr("TUTORIAL_16"),
	tr("TUTORIAL_17"),
	tr("TUTORIAL_18"),
	tr("TUTORIAL_19"),
	tr("TUTORIAL_20"),
	tr("TUTORIAL_21"),
	tr("TUTORIAL_22"),
	tr("TUTORIAL_23"),
	tr("TUTORIAL_24"),
	tr("TUTORIAL_25"),
	tr("TUTORIAL_26"),
	tr("TUTORIAL_27")
]

var counter = 1
var utolsoelotti = len(texts)-2
var utolso = len(texts)-1
var canprogress = true
func cantProgress() -> void:
	canprogress = false
	$Label/RichTextLabel.text = tr("OBJECTIVE_REMINDER")
	counter += 1

func canProgress() -> void:
	canprogress = true
	$Label/RichTextLabel.text = tr("PROMPT_CONTINUE")
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
					$Label/RichTextLabel.text = tr("PROMPT_EXIT")
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
