extends MarginContainer

@onready var CharacterContainer: HBoxContainer = %CharacterContainer
@onready var Game = $"../.."
const CharacterDisplayContainer = preload("res://Scenes/character_display_containertscn.tscn")
var initiativeOrder = 0
var turnCount = 0 #this is used to keep count of what part in the initiative we're in
var activeParticipant = "0"
var lock = 0


func _makeTurns():
	initiativeOrder = get_tree().get_nodes_in_group("Heroes") + get_tree().get_nodes_in_group("Enemies")
	for i in Game.get_tree().get_nodes_in_group("Heroes").size() + get_tree().get_nodes_in_group("Enemies").size():
		#print(initiativeOrder[i])
		CharacterContainer.add_child(CharacterDisplayContainer.instantiate())
		


func _doTurn():
	activeParticipant = initiativeOrder[turnCount] #finds the current turn holder
	activeParticipant._takeTurn() #initiate turn
	while lock == 0:
		await get_tree().create_timer(.1).timeout #wait for turn to finish
	lock = 0 #reset lock for next person
	Game.lock = 1 #tell the game that It can continue
	#_moveTurnOrder() #Game manager will handle incrementing turns
	#repeat turn
	


func _moveTurnOrder():
	#we increment the turn order every time
	turnCount+=1
	#When we reach the end of the array, we reset the count and restart
	if turnCount == initiativeOrder.size():
		turnCount = 0
	Game.lock = 1 #Game set to continue
