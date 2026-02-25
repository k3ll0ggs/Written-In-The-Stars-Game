extends Control

@onready var gameManager = $"../../../../.."
@onready var turnOrderContainer = $"../../../../../Top UI/TurnOrder/TurnIconContainer"
@onready var UIContainer = $"../../../../../Bottom UI/UI Healthbars/Panel/UI Container"
@onready var menu = $"../../../../../CanvasLayer/Action Menu"
var turnPrefab = preload("res://Battle Systems/Scenes/turn_icon.tscn")
var UI = preload("res://Battle Systems/Scenes/character_ui.tscn").instantiate()
var turn

var currentState = state.waiting
var positionState
enum state {
	waiting,
	active,
	backline,
	frontline,
	dead
}

var data = {
	"Name": null,
	"Position": null,
	"Max HP": 0,
	"Current HP": 1,
	"Max SP": 2,
	"Current SP": 3,
	"Debuffs": {}
}

func _learnSelf(identity, partyNum):
	data["Name"] = identity 
	data["Position"] = partyNum
	print(data["Name"], data["Position"])
	if data["Position"] <= 2:
		_changeState(state.waiting)
		_createTurn()
		_createUI()
	else:
		_changeState(state.backline)


func _startTurn():
	_changeState(state.active)
	menu._changeOwners(self)
	
	
func _endTurn():
	turn.turnFinished.emit()
	_changeState(state.waiting)
	gameManager.makeText.emit((data["Name"] + " finished their turn"))




func _changeSelf():
#this is the stuff that needs to get updated
	#_changeTurn()
	if currentState != state.backline:
		turn._identify(data["Name"])
		turn.turnHolder = self
	#_changeUI()
		UI.hero = self
		UI._update()
	pass 
	#this works, we just need to figure out what we actually want to do when swapping
		#it's either we just swap the data, or we physically swap the actual character
	
	

func _createTurn():
	turn = turnPrefab.instantiate()
	turn.turnHolder = self
	turnOrderContainer.add_child(turn)
	turn._identify(data["Name"])

func _createUI():
	UI.hero = self
	UIContainer.add_child(UI)
	UI._update()

	
func _die():
	_endTurn()
	#turn.callNextTurn.emit()
		#can't just use callNextTurn.emit() since we also need to change states
			#I'll be using _endTurn() for now
				#this is the same problem in _moveTurn
	turn.queue_free()
	_createTurn() #revival works REALLY well
	
func _revive():
	_createTurn() #I'm just turning this into a callable function
	
func _moveTurn(newTurnNum):
	_endTurn()
	#turn.callNextTurn.emit()
	#we technically dont need to call another turn here.
		#consider this if we make character specific moves
			#Look to _die() as to why we have _endTurn() and turn.cNT.emit() in the same function
	turn._moveTurn(newTurnNum)
	
func _changeHealth(amount):
	data["Current HP"] = data["Current HP"] + amount
	UI._update() #we can maybe just put this as part of _process()
	if data["Current HP"] <= 0:
		print("This person should be dead")
		_die()

func _changeMana(amount):
	data["Current SP"] = data["Current SP"] + amount
	UI._update()
	if data["Current SP"] < 0:
		print("Mana debt? That shouldn't be right")
	
func _changeState(newState):
	currentState = newState
	match currentState:
		state.waiting:
			pass
		state.active:
			pass
	
	
func _get_drag_data(at_position: Vector2):
	return self


func _can_drop_data(at_position: Vector2, data: Variant):
	if data.is_in_group("Hero") and currentState != state.active and data.currentState != state.active and data != self:
		return true #yes, I know this conditional looks like dog shit, but it does what it needs to do

func _drop_data(at_position: Vector2, data: Variant) -> void:
	gameManager._swapHeroes(data, self)
	print("dropping done")
