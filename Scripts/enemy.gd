extends Node2D

@onready var menu = $"../../Menus/BattleMenu"
@onready var order = $"../../CanvasLayer/TurnOrder"
@onready var UI = $"CanvasLayer2/MarginContainer/UI Contatiner"
@onready var game = $"../.."
var charUI = preload("res://Scenes/character_ui.tscn")

var heroName = "pep"
var identity = 0
var lock = 0
var origin = 0
var characterData

var currentState = state.off
enum state{
	off,
	on,
	hovered,
	selected,
	healthy,
	bloodied,
	mortal
}

var healthState = state.healthy

func _changeState(newState):
	if currentState == newState:
		print(str(self) + " cannot change states")
	else:
		currentState = newState
		match currentState:
			state.off:
				$TextureButton.hide()
			state.on:
				$TextureButton.show()
				$TextureButton.self_modulate.a = .2
			state.hovered:
				$TextureButton.self_modulate.a = .5
			state.selected:
				$TextureButton.self_modulate.a = 1
		#simple state changing for the hero class, use this on other targets as well
		print(str(self) + " changed states to " + str(currentState))
	

#hero.gd should hold all info about every hero so that they can change into whatever heroes are in the party
	#ok new idea, hero.gd should copy the data of heroes to turn into them. It should not store everything. That'd be a terrible idea
		#this is Byron from the future, I have decided to use hero as a brindge between saved/global stats and the rest of the combat systems (ie: UI and menus)

#fuck you. *removes your stats* 
	#(This is temp, it's only like this to test point_data.gd)
var health = 0
var currentHealth = 0
var mana = 0
var currentMana = 0
var attack = 0
var defence = 0
var magic = 0


func _ready():
	#order._createTurn(self) #This causes errors in Turn Order, I don't understand why
	$TextureButton.hide()
	#figure out who they are
	_changeEnemy()
	_update()

func _changeEnemy():
	#we need a function to change the enemy's info to whatever monster they should be
	_updateStats()
	


#this function copies the stats of the global character data to the hero entity
func _updateStats():
	health = 20
	currentHealth = 20
	mana = 5
	currentMana = 5
	attack = 5
	defence = 5
	magic = 5


func _startTurn():
	#we need a way for the enemy to know what mv ethey should do
		#Maybe state machine based on health?
	_doTurn(1,1)
	
func _doTurn(moveName, targets):
	_endTurn()

func _endTurn():
	#move back when they're done acting
	print(str(self) + " did their action")
	order._moveTurnOrder()


#both of these are to be used when someone takes damage/gets healed and casting skills, also for calling mid fight for weird mechanics
	#we don't have death status/state yet
func _changeHealth(amount):
	_update()
	currentHealth = currentHealth + amount
	if currentHealth <= 0:
		print("This person should be dead")
		order._removeTurn(self)
	elif currentHealth/health < .25 & healthState != state.mortal:
		_changeState(state.mortal)
		print(str(self) + "is mortal")
	elif currentHealth/health < .5 & healthState != state.bloodied:
		_changeState(state.bloodied)
		print(str(self) + "is bloodied")

func _changeMana(amount):
	currentMana = currentMana + amount
	if currentHealth < 0:
		print("Mana debt? That shouldn't be right")



var targets
func _on_texture_button_pressed() -> void:
	targets = ""
	if game.currentState == game.state.targeting:
		if game.moveInfo["Supportive"] == "na":
			var friends = $"../".get_children()
			for i in friends.size():
				friends[i]._changeState(state.selected)
			targets = friends
		else:
			_changeState(state.selected)
			targets = self
		game._targetingFinished(targets)

func _on_texture_button_mouse_entered() -> void:
	if game.currentState == game.state.targeting and currentState != state.selected:
		if game.moveInfo["Supportive"] == "na":
			var friends = $"../".get_children()
			for i in friends.size():
				friends[i]._changeState(state.hovered)
		else:
			_changeState(state.hovered)


func _on_texture_button_mouse_exited() -> void:
	if game.currentState == game.state.targeting and currentState != state.selected:
		if game.moveInfo["Supportive"] == "na":
			var friends = $"../".get_children()
			for i in friends.size():
				friends[i]._changeState(state.on)
		else:
			_changeState(state.on)

func _update():
	$EnemyHealthBar.max_value = health
	$EnemyHealthBar.value = currentHealth
