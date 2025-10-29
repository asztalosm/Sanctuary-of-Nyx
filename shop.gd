extends Node2D
@export var inrange = false
@export var ingui = false
@export var shopitems = [
	{"Title": "Sharper blades",
	"Description": "Swords deal 50% more damage.",
	"Cost": 80 + randi_range(1,20)
	},
	
	{"Title": "Speedster shoes",
	"Description": "Makes you move 10% faster.",
	"Cost": 30 + randi_range(1,20)
	},
	
	{"Title": "Forbidden knowledge",
	"Description": "Magic attacks deal 50% more damage and cooldown is reduced by 30%",
	"Cost": 80 + randi_range(1,20)
	},
	
	{"Title": "Enhanced quiver",
	"Description": "Archer attack cooldown reduced by 30%",
	"Cost": 100 + randi_range(1,20)
	},
	
	{"Title": "Light armor",
	"Description": "Incoming damage reduced by 0.2",
	"Cost": 40 + randi_range(1,20)
	},
	
	{"Title": "Good shot",
	"Description": "Critical hit chance increased by 5%",
	"Cost": 50 + randi_range(1,20)
	},
	
	{"Title": "Skill point",
	"Description": "Gives you a skill point",
	"Cost": 30 + randi_range(1,20)
	}
]
@onready var player = get_parent().get_parent().get_node("Character").get_node("Player")
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		$AnimatedSprite2D.animation = "inrange"
		inrange = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		$AnimatedSprite2D.animation = "default"
		inrange = false

func _ready() -> void:
	for button in $ShopGUI/Buttons.get_children():
		var usednum = randi_range(0, len(shopitems)-1)
		button.get_node("Control").get_node("Title").text = shopitems[usednum].Title
		button.get_node("Control").get_node("Description").text = shopitems[usednum].Description
		button.get_node("Control").get_node("Cost").text =  "[imgresize=16]res://resources/coin.png[color=cfa951] " + str(shopitems[usednum].Cost)

func _process(_delta: float) -> void:
	if inrange and Input.is_action_just_pressed("E"):
		if !ingui:
			get_tree().paused = true
			$ShopGUI/Buttons/Button.grab_focus()
			ingui = true
			$ShopGUI.visible = true
		else:
			get_tree().paused = false
			ingui = false
			$ShopGUI.visible = false

func _on_button_pressed(source: BaseButton) -> void:
	for item in shopitems:
		if source.get_node("Control").get_node("Title").text == item.Title:
			if get_parent().get_parent().coins > item.Cost:
				source.disabled = true
				source.get_node("Sold").visible = true
				match item.Title:
					"Sharper blades":
						player.Characters[0].AttackDamage *= 1.5
						player.Characters[2].AttackDamage *= 1.5
					"Speedster shoes":
						player.speed *= 1.1
					"Forbidden knowledge":
						player.Characters[1].AttackDamage *= 1.5
					"Enhanced quiver":
						player.arrowcd *= 0.7
					"Light armor":
						player.globalcharacterstats.BaseDefense += 0.2
					"Good shot":
						player.critchance += 5
					"Skill point":
						player.globalcharacterstats.SkillPoints += 1
			else:
				source.get_node("Control").get_node("Cost").text = "[imgresize=16]res://resources/coin.png[color=ff1919] " + str(item.Cost)
				await get_tree().create_timer(1.5).timeout
				source.get_node("Control").get_node("Cost").text = "[imgresize=16]res://resources/coin.png[color=cfa951] " + str(item.Cost)
			player.recheckstats()
				
