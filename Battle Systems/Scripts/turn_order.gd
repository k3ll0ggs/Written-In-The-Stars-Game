extends Control

@onready var Icons = $TurnIconContainer

signal callTurn

#These two functions used to be in the container, but I figured I should seperate the order functions from the orgaization functions
func _startTurn():
	Icons.get_child(0).callTurn.emit(0)
	#Ideally, this should only ever have to run once

func _nextTurn(number):
	number = number + 1 #note to self: number+1 does not increment
	if number >= Icons.get_child_count():
		Icons.get_child(0)._callTurn()
	else:
		Icons.get_child(number)._callTurn()
		#get number from the previous turn, any counting we do here will be ruined the moment we change turn order

func _on_call_turn(number) -> void:
	_organize()
	Icons.get_child(number).callTurn.emit()
	pass # Replace with function body.
		


func _organize():
	for i in Icons.get_child_count():
		Icons.get_child(i).order = i #this should make all of the turns have their correct order
