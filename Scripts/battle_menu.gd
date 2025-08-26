extends VBoxContainer

@onready var Game = $".."
@onready var Attack = $Attack
@onready var Pass = $Pass

var acting = "0"
var remember = "0"

func _ready():
	$".".hide()

func _showMenus(acting):
	remember = acting #this fucking thing won't remember the value so we have to save it else where
	$".".show()


#this is for skipping turns
func _on_pass_pressed():
	_actionFinalized()

#this is for attacking, they're both empty
func _on_attack_pressed():
	_actionFinalized()



#no matter what button is pressed, the menus should always be hidden and the lock should be set. Just direct any actions in menus to this
func _actionFinalized():
	$".".hide()
	await get_tree().create_timer(2).timeout
	remember.lock = 1 #active player is set to continue
