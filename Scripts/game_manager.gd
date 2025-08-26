extends Node2D

#@onready var hero = $Hero
@onready var menu = $BattleMenu
@onready var order = $CanvasLayer/TurnOrder
@onready var party = $PartyInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	#this is setting up the stage
	_lineUp() #we also need a func for adding enemies
	#I'm just putting these waits here so that all combatants get fully created
	await get_tree().create_timer(1).timeout
	order._makeTurns() #turn order created
	await get_tree().create_timer(1).timeout
	_turnProcess() #start overseeing turn order


#This section is for adding the party
@onready var heroStage = $HeroStage
#@onready var UIContainer = $HeroStage
const hero = preload("res://Scenes/hero.tscn")
#const heroUI = preload("res://Scenes/character_ui.tscn")

var hero1ID = "0" #I'm using these as a tracker for the 3 party members for future use
var hero2ID = "0" #When heroes get created, they change these values to their references
var hero3ID = "0"

var hero1UI = "0" #lets also do the same with the UI, surely it can't hurt
var hero2UI = "0"
var hero3UI = "0"

func _lineUp():
	#ask party_info to check whos in the party
	var partyList = party.PartyOrder
	#the first three go to stage, everyone else should go to reserve
	if partyList[0] != "0":
		var inst = hero.instantiate()
		inst.position = Vector2(75,290)
		heroStage.add_child(inst)
		hero1ID._createUI()
	if partyList[1] != "0":
		var inst = hero.instantiate()
		inst.position = Vector2(100,145)
		heroStage.add_child(inst)
		hero2ID._createUI()
	if partyList[2] != "0":
		var inst = hero.instantiate()
		inst.position = Vector2(50,435)
		heroStage.add_child(inst)
		hero3ID._createUI()
	#heroes find their identity through their position, check hero.gd to see
		#now that we have heroIDs, we could actually change this ^
	#reserve party members should maybe be a party_info job. Maybe they get their own turn?




#this is the main function of game_manager.
#it tells other scripts when to run; namely turn_order when to do turns and move through turn order
var lock = 0
func _turnProcess():
	await get_tree().create_timer(1).timeout #I'm slowing down the game so it doesn't kill itself
	#first we tell turn_order to make a turn
	print("entering _doTurn()")
	order._doTurn()
	#we should wait here until the enemy makes a move, or the player decides on a move
	while lock == 0:
		print("in _doTurn()")
		await get_tree().create_timer(.1).timeout
	lock = 0 #reset lock

	#next, we want to move the turn order along
	#we could probably attach moving the turn order to _doTurn(), but I'm doing this incase something comes up
	print("entering _moveTurnOrder()")
	order._moveTurnOrder()
	#wait here a moment
	while lock == 0:
		print("in _moveTurnOrder()")
		await get_tree().create_timer(.1).timeout
	lock = 0 #reset lock

	print("turn completed")
	#Good turn!(hopefully) If the enemy isn't dead, then we gotta do it again
	
	#check party status
	#redo turn
	_turnProcess() #IDK how to do recursion without overflowing, so we have a wait statement at the top to stall
