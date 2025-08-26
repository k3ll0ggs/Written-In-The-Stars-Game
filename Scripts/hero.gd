extends Node2D
var PointSprite = preload("res://Assets/placeholder_point.png")
var BelSprite = preload("res://Assets/placeholder_bel.png")
var CroweSprite = preload("res://Assets/placeholder_crowe.png")
var BowlderSprite = preload("res://Assets/placeholder_bowlder.png")
var FowleSprite = preload("res://Assets/placeholder_fowle.png")
var NiciaSprite = preload("res://Assets/placeholder_nicia.png")
@onready var party = $"../../PartyInfo"
@onready var menu = $"../../BattleMenu"
@onready var order = $"../../CanvasLayer/TurnOrder"
@onready var UI = $"CanvasLayer2/MarginContainer/UI Contatiner"
@onready var game = $"../.."
var charUI = preload("res://Scenes/character_ui.tscn")

var heroName = "pep"
var identity = 0
var lock = 0
var origin = 0

#hero.gd should hold all info about every hero so that they can change into whatever heros are in the party

@export var health = 5
@export var attack = 5
@export var defence = 5
@export var speed = 5

func _ready():
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
	if party.PartyOrder[identity] == "Point":
		$Icon.texture = PointSprite
	elif party.PartyOrder[identity] == "Bel":
		$Icon.texture = BelSprite
	elif party.PartyOrder[identity] == "Crowe":
		$Icon.texture = CroweSprite
	elif party.PartyOrder[identity] == "Bowlder":
		$Icon.texture = BowlderSprite
	elif party.PartyOrder[identity] == "Nicia":
		$Icon.texture = NiciaSprite
	elif party.PartyOrder[identity] == "Fowle":
		$Icon.texture = FowleSprite

func _takeTurn():
	#the hero should communicate somehow with the battle menu to create a skill menu, something unique to the character
	self.position = Vector2(320, 290) #move forward when the turn starts
	
	menu._showMenus(self) #the hero will have to choose something from the menu, we lock them during this
	while lock == 0:
		print("in _showMenus()")
		await get_tree().create_timer(.1).timeout
	lock = 0 #reset lock
	
	#after something is chose, we should probably have something where the party member acts
	#either raw code or a function could work, I'll save this for when we actually have actions to perform
	
	#move back when their done acting
	self.position = origin
	print(str(self) + " did their action")
	order.lock = 1 #unlock

@onready var UIcontainer = $"../../CanvasLayer2/MarginContainer/UI Contatiner"
var corrUI = "0"
func _createUI():
	var inst = charUI.instantiate()
	inst._connect(self)
	UIcontainer.add_child(inst)
