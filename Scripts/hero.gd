extends Node2D
var PointSprite = preload("res://Assets/placeholder_point.png")
var BelSprite = preload("res://Assets/placeholder_bel.png")
var CroweSprite = preload("res://Assets/placeholder_crowe.png")
var BowlderSprite = preload("res://Assets/placeholder_bowlder.png")
var FowleSprite = preload("res://Assets/placeholder_fowle.png")
var NiciaSprite = preload("res://Assets/placeholder_nicia.png")

#@onready var party = $"../../PartyInfo" I learned how to make PartyInfo into a global script
@onready var menu = $"../../Menus/BattleMenu"
@onready var order = $"../../CanvasLayer/TurnOrder"
@onready var UI = $"CanvasLayer2/MarginContainer/UI Contatiner"
@onready var game = $"../.."
var charUI = preload("res://Scenes/character_ui.tscn")
var icon = preload("res://icon.svg")
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
	selected
}

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
	order._createTurn(self)
	$HeroPauseMenu.hide()
	$TextureButton.hide()
	#figure out who they are
	if self.position == Vector2(75,290):
		game.hero1ID = self
		identity = 0
		origin = self.position
	elif self.position == Vector2(100,145):
		game.hero2ID = self
		identity = 1
		origin = self.position
	elif self.position == Vector2(50,435):
		game.hero3ID = self
		identity = 2
		origin = self.position
	_changeHero()


func _changeHero(): #I should've just used a switch case... Oh well!
	if PartyInfo.PartyOrder[identity] == "Point":
		$Icon.texture = PointSprite
		characterData = PointData
		_updateStats()
	elif PartyInfo.PartyOrder[identity] == "Bel":
		$Icon.texture = BelSprite
	elif PartyInfo.PartyOrder[identity] == "Crowe":
		$Icon.texture = CroweSprite
	elif PartyInfo.PartyOrder[identity] == "Bowlder":
		$Icon.texture = BowlderSprite
	elif PartyInfo.PartyOrder[identity] == "Nicia":
		$Icon.texture = NiciaSprite
	elif PartyInfo.PartyOrder[identity] == "Fowle":
		$Icon.texture = FowleSprite


#this function copies the stats of the global character data to the hero entity
func _updateStats():
	health = characterData.Health
	currentHealth = characterData.CurrentHealth
	mana = characterData.Mana
	currentMana = characterData.CurrentMana
	attack = characterData.Attack
	defence = characterData.Defence
	magic = characterData.Magic


func _startTurn():
	#the hero should communicate somehow with the battle menu to create a skill menu, something unique to the character
		#this will likely be done on the menu's side, it will read info move data that the hero gains from its global identity as well as the save file
	self.position = Vector2(320, 290) #move forward when the turn starts
	
	
	game._changeState(game.state.menuSelect)
	menu._showMenus(self)
	
	#after something is chosen, we should probably have something where the party member acts
	#either raw code or a function could work, I'll save this for when we actually have actions to perform

func _doTurn(moveName, targets):
	match moveName: #we're going to keep track of every move the character could end up making, this is very inefficient
		"Placeholder Name":
			print(str(self) + " attacked " + str(targets))
			
		"Placeholder Name 2": #this attacks anyone for 1 hp
			print(str(self) + " buffed " + str(targets))
			targets._changeHealth(-1)
			
		"Placeholder Name 3": #this attacks EVERYONE for 1 hp
			print(str(self) + " buffed " + str(targets))
			for i in targets.size():
				targets[i]._changeHealth(-1)
			
		"Placeholder Name 4":
			print(str(self) + " attacked " + str(targets))
			
	#whenever the move is finished, the hero should end their turn
	menu._actionFinalized()

func _endTurn():
	#move back when they're done acting
	self.position = origin
	print(str(self) + " did their action")
	order._moveTurnOrder()


#both of these are to be used when someone takes damage/gets healed and casting skills, also for calling mid fight for weird mechanics
	#we don't have death status/state yet
func _changeHealth(amount):
	currentHealth = currentHealth + amount
	corrUI._update()
	if currentHealth <= 0:
		print("This person should be dead")
		order._removeTurn(self)

func _changeMana(amount):
	currentMana = currentMana + amount
	corrUI._update()
	if currentHealth < 0:
		print("Mana debt? That shouldn't be right")


func _updateGlobal(): #when the battle ends, we need to update the global sheet with what changed
	characterData.Health = health
	characterData.CurrentHealth = currentHealth
	characterData.Mana = mana
	characterData.CurrentMana = currentMana
	characterData.Attack = attack
	characterData.Defence = defence
	characterData.Magic = magic


@onready var UIcontainer = $"../../CanvasLayer2/MarginContainer/UI Contatiner"
var corrUI = "0"
func _createUI():
	var inst = charUI.instantiate()
	inst._connect(self)
	UIcontainer.add_child(inst)
	print(corrUI)


var targets
func _on_texture_button_pressed() -> void:
	targets = ""
	if game.currentState == game.state.targeting:
		if game.moveInfo["Supportive"] == "ya":
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
		if game.moveInfo["Supportive"] == "ya":
			var friends = $"../".get_children()
			for i in friends.size():
				friends[i]._changeState(state.hovered)
		else:
			_changeState(state.hovered)


func _on_texture_button_mouse_exited() -> void:
	if game.currentState == game.state.targeting and currentState != state.selected:
		if game.moveInfo["Supportive"] == "ya":
			var friends = $"../".get_children()
			for i in friends.size():
				friends[i]._changeState(state.on)
		else:
			_changeState(state.on)
