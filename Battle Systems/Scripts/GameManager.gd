extends Node2D

@onready var heroStage = $"Hero Stage"
@onready var turnContainer = $"Top UI/TurnOrder/TurnIconContainer"
@onready var textContainer = $"Bottom UI/Text UI/Panel/ScrollContainer/VBoxContainer"
var hero = preload("res://Battle Systems/Scenes/Hero.tscn")
var textBox = preload("res://Battle Systems/Scenes/text_box.tscn")

signal startBattle
signal checkStatus
signal nextTurn
signal intervene
signal endBattle
signal makeText


var party = BattleData.party

func _ready():
	_populate()
	startBattle.emit()
	makeText.emit("balls")
	OS.alert("bitches")

func _populate():
	_addHeroes(party)
	_addEnemies()


# various signals
func _on_start_battle() -> void:
	print("Battle Start!")
	turnContainer.get_child(0).callTurn.emit(0)

func _on_check_status(turn) -> void:
	print("checking status")
	#check to see if any party memebers are alive
	#check to see if any enemies are alive
	turn.callNextTurn.emit()



func _on_next_turn(number) -> void:
	number = number + 1
	if number >= turnContainer.get_child_count():
		number = 0
	turnContainer.get_child(number).callTurn.emit(number)

func _on_end_battle() -> void:
	print("Battle end!")

func _on_make_text(text) -> void:
	var newTextBox = textBox.instantiate()
	newTextBox.text = text
	textContainer.add_child(newTextBox)
	#this is to be emit() by other nodes, game manager will handle their calls
	#should maybe make this a scroll box for how much text might get put in here


func _addHeroes(heroParty):
	for i in len(heroParty):
		if heroParty[i] != null && i <= 2:
			heroStage.get_child(0).get_child(i).get_child(0).add_child(hero.instantiate())
			heroStage.get_child(0).get_child(i).get_child(0).get_child(0)._learnSelf(heroParty[i], i)
			#scuffed as shit, but it does make characters
			#should make a second part that adds heroes to reserve
		elif heroParty[i] != null:
			heroStage.get_child(0).get_child(i).get_child(0).add_child(hero.instantiate())
			heroStage.get_child(0).get_child(i).get_child(0).get_child(0)._learnSelf(heroParty[i], i)
	
func _addEnemies():
	pass

func _swapHeroes(hero1, hero2):
	print(hero1.data)
	var tempHero = hero1.data
	hero1.data = hero2.data
	hero2.data = tempHero
	print(hero1.data)
	hero1._changeSelf()
	hero2._changeSelf()
#it half works, we need to get the rest of the changes properly implemented
