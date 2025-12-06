extends MarginContainer

@onready var CharacterContainer: HBoxContainer = %CharacterContainer
@onready var Game = $"../.."
const token = preload("res://Scenes/turnOrderToken.tscn")
var initiativeOrder = 0
var turnCount = 0 #this is used to keep count of what part in the initiative we're in
var activeParticipant = "0"
var lock = 0


func _countTurns():
	initiativeOrder = CharacterContainer.get_children()


func _createTurn(entity): #I dont know if this works lmao
	var inst = token.instantiate()
	inst.parentEntity = entity #we save whoever owns this token to the token itself
	#inst.sprite = entity.icon #this doesn't work rn
	CharacterContainer.add_child(inst)
	_countTurns()
	return inst
	
func _removeTurn(entity): #there might be a way to just make it so that we can straight up remove the turn that's called, but I'm gonna try this way first
	for i in CharacterContainer.get_children().size():
		if initiativeOrder[i].parentEntity == entity:
			CharacterContainer.remove_child(initiativeOrder[i])
			initiativeOrder[i].queue_free()
			if i <= turnCount:
				turnCount = turnCount - 1
	_countTurns()


func _doTurn(): #the current _doTurn() method causes overflows in the array if turns are removed, we need a better way to set up a turn queue
	activeParticipant = initiativeOrder[turnCount].parentEntity #finds the current turn holder
	activeParticipant._startTurn() #initiate turn
	




func _moveTurnOrder():
	#we increment the turn order every time
	turnCount+=1
	#When we reach the end of the array, we reset the count and restart
	if turnCount == initiativeOrder.size():
		turnCount = 0
	_doTurn()
