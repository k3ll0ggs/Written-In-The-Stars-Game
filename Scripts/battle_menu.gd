extends VBoxContainer

@onready var Game = $"../.."
@onready var SkillMenu = $"../SkillMenu"
@onready var ItemMenu = $"../ItemMenu"
@onready var Attack = $Attack
@onready var Pass = $Pass

enum state{
	skill,
	item,
	close
}

var currentState = state.close

var acting = "0"
var remember = "0"

func _ready():
	$".".hide()



func _changeState(newState):
	if currentState == newState:
		print("already in state")
	else:
		match currentState:
			state.skill:
				SkillMenu._deleteOptions()
			state.item:
				ItemMenu._deleteOptions()
		currentState = newState




func _showMenus(acting):
	remember = acting #this fucking thing won't remember the value so we have to save it else where
	$".".show()

#this is for attacking, yes it's empty for now
func _on_attack_pressed():
	_actionFinalized()

func _on_skill_pressed(): #Skill should open a menu
	if currentState != state.skill:
		SkillMenu._makeOptions(remember.characterData.stats["Skills"])
		_changeState(state.skill)
	else:
		_changeState(state.close)

func _on_item_pressed() -> void:
	if currentState != state.item:
		ItemMenu._makeOptions(GlobalInventory.inventory["Inventory"])
		_changeState(state.item)
	else: 
		_changeState(state.close)



func _on_limit_break_pressed(): #Limit break should also probably open a menu, we're still concepting this
	_actionFinalized()



func _on_defend_pressed():
	#we need to tell the hero that they're defending
	_actionFinalized()

#no matter what button is pressed, the menus should always be hidden and the lock should be set. Just direct any actions in menus to this
func _actionFinalized():
	Game._changeState(Game.state.spectate)
	_changeState(state.close)
	remember._endTurn()
