extends VBoxContainer

@onready var Game = $".."
@onready var SkillMenu = $"../SkillMenu"
@onready var Attack = $Attack
@onready var Pass = $Pass

var acting = "0"
var remember = "0"

func _ready():
	$".".hide()

func _showMenus(acting):
	remember = acting #this fucking thing won't remember the value so we have to save it else where
	$".".show()

#this is for attacking, yes it's empty for now
func _on_attack_pressed():
	_actionFinalized()

func _on_skill_pressed(): #Skill should open a menu
	if SkillMenu.menuOpen == 0:
		SkillMenu._makeOptions(remember.characterData.stats["Skills"])
	else:
		SkillMenu._deleteOptions()


func _on_limit_break_pressed(): #Limit break should also probably open a menu, we're still concepting this
	_actionFinalized()



func _on_defend_pressed():
	#we need to tell the hero that they're defending
	_actionFinalized()

#no matter what button is pressed, the menus should always be hidden and the lock should be set. Just direct any actions in menus to this
func _actionFinalized():
	$".".hide()
	await get_tree().create_timer(2).timeout
	remember.lock = 1 #active player is set to continue
