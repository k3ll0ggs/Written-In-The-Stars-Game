extends Node2D

@onready var menus = $Menus
@onready var order = $CanvasLayer/TurnOrder
@onready var heroStage = $HeroStage
@onready var enemyStage = $EnemyStage

enum state{
	doNothing, #as the name implies, they do nothing
	preBattle, #only used for entering the fight
	menuSelect, #use when the player needs to choose what to do
	targeting, #picking an enemy/ally to affect
	spectate, #either for watching the enemy or for witnessing an action
	cutscene, #only for monologing, no actions should overwrite this (outside of a skip button)
	intervene, #only used when the player wants to help the party
	endGame #only used for exiting the fight
}

var interveneState = state.doNothing
var currentState = state.doNothing
var previousState = state.doNothing

const hero = preload("res://Scenes/hero.tscn")

var hero1ID = "0" #I'm using these as a tracker for the 3 party members for future use
var hero2ID = "0" #When heroes get created, they change these values to their references
var hero3ID = "0"

var hero1UI = "0" #lets also do the same with the UI, surely it can't hurt
var hero2UI = "0"
var hero3UI = "0"

var targets = ""
var chosen = ""

# thank you Shaggy Dev for the state tutorial, I have most definitely butchered it
func _process(delta: float) -> void:	
	match currentState: #idk anything about gdscript, but match just seems like a switch case?
		state.menuSelect:
			menus.show()
		state.targeting:
			if Input.is_key_pressed(KEY_ESCAPE):
				_changeState(previousState)
				for i in targets.size():
					targets[i]._changeState(targets[i].state.off)

func _changeState(newState):
	if currentState == newState:
		print("Cannot change states")
		pass
	elif currentState == state.cutscene:
		print("You cannot escape the cutscene")
		pass
	else:
		previousState = currentState
		currentState = newState
		print("state changed to " + str(currentState))

	match currentState:
		state.preBattle:
			_startUp()
		state.menuSelect:
			menus.show()
		state.targeting:
			menus.hide()
		state.spectate:
			menus.hide()
		state.cutscene:
			menus.hide()
		state.intervene:
			pass
		state.endGame:
			_endBattle()

func _input(event):
	if event.is_action_pressed("Pause"):
		_intervene()

var pause = "0"
func _intervene(): #We'll probably need to put in something that stops the player from activating this during cutscenes
	if interveneState == state.intervene:
		print("The player leaves the fight")
		menus.process_mode = Node.PROCESS_MODE_INHERIT
		for i in pause.size():
			pause[i].hide()
		get_tree().paused = false
		interveneState = state.doNothing
	elif interveneState == state.doNothing:
		print("The player steps in")
		menus.process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().paused = true
		for i in pause.size():
			pause[i].show()
		interveneState = state.intervene
	else:
		print("_intervene(): This message is an error")


# I'm treating this as if the game was told to start an encounter
func _ready():
	await get_tree().create_timer(.5).timeout #treat this as loading into the arena
	_changeState(state.preBattle)



func _startUp():
	#this is the game setting up the stage
	_lineUp() #we need to add enemies in the future
	#order._makeTurns() #turn order created #we dont need this anymore, entities call their own turns now
	#once everything is set, then we should move on to the fighting
	_changeState(state.spectate)
	print("entering _doTurn()")
	order._doTurn()


#This section is for adding the party
func _lineUp():
	#ask party_info to check whos in the party
	var partyList = PartyInfo.PartyOrder
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
	pause = get_tree().get_nodes_in_group("Pause") #this is just heare to grab all menu entries that can appear

var moveInfo
func _targeting(move, buttonCaller):
	targets = ""
	chosen = ""
	moveInfo = move
	if moveInfo["Supportive"] == "y":
		targets = heroStage.get_children() #target allies
		for i in targets.size():
			targets[i]._changeState(targets[i].state.on)
	
	elif moveInfo["Supportive"] == "ya":
		targets = heroStage.get_children() #target ALL allies
		for i in targets.size():
			targets[i]._changeState(targets[i].state.on)
	
	elif moveInfo["Supportive"] == "n":
		targets = enemyStage.get_children() #target enemies
		for i in targets.size():
			targets[i]._changeState(targets[i].state.on)
	
	elif moveInfo["Supportive"] == "na":
		targets = enemyStage.get_children() #target ALL enemies
		for i in targets.size():
			targets[i]._changeState(targets[i].state.on)
	
	elif moveInfo["Supportive"] == "s":
		pass #I don't remember if we can easily get those nodes here, this may not even be used anyways
	return

func _targetingFinished(selected):
	_changeState(state.spectate) #make sure nothing interferes with the targeting ui. having this chnage state take place after the for loop here broke the states of the targets
	for i in targets.size():
		targets[i]._changeState(targets[i].state.off)
	order.activeParticipant._doTurn(moveInfo["Name"], selected)


func _endBattle(): #we need to leave combat at some point
	var partyList = PartyInfo.PartyOrder #also, update the global stat sheets of the party
	if partyList[0] != "0":
		hero1ID._updateGlobal()
	if partyList[1] != "0":
		hero2ID._updateGlobal()
	if partyList[2] != "0":
		hero3ID._updateGlobal()
