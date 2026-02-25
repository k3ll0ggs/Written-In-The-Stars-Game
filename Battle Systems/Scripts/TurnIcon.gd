extends Panel

#this is the part I coded
#the icons should house what turn they are and whose they are
@onready var gameManager = $"../../../.."
@onready var turnContainer = $".."

signal callTurn
signal turnFinished
signal callNextTurn

var turnHolder
var order
var currentState = state.waiting
var interveneState = state.unlocked

enum state{
	waiting, #used on all turns by default
	active, #used on whoever's turn is currently the active turn
	unlocked, #lets the turn be dragged around
	locked #used on enemy and active turns, we don't want them moving on their own
}

func _changeState(newState):
	print("changing state")
	currentState = newState
	match currentState:
		state.waiting:
			print("waiting")
			$ActiveMarker.hide()
		state.active:
			print("active")
			$ActiveMarker.show()

func _identify(entityName):
	$Label.text = entityName
	turnContainer._organize()


func _on_call_turn(number) -> void:
	if order == number:
		turnContainer._organize()
		_changeState(state.active)
		turnHolder._startTurn()
		print("Your turn, ", turnHolder, order)

func _on_turn_finished() -> void:
	gameManager.checkStatus.emit(self)

func _on_call_next_turn() -> void:
	turnContainer._organize()
	gameManager.nextTurn.emit(order)
	_changeState(state.waiting)


func _moveTurn(turnNumber):
	turnContainer._moveTurn(self, turnNumber)

#this code is from gpt, I am now breaking it down to understand
func _ready():
	$ActiveMarker.hide()
	#simple mouse needs to know what to click
	mouse_filter = Control.MOUSE_FILTER_STOP


func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and currentState != state.active:
		#all dragging is performed by the parent, in this case the control node
		if event.pressed:
			get_parent().start_drag(self)
		else:
			get_parent().stop_drag()
