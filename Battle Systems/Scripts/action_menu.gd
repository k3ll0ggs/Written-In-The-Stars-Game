extends Control

@onready var attackButton = $VBoxContainer/Attack
@onready var spellcastButton = $VBoxContainer/Spellcast
@onready var itemButton = $VBoxContainer/Item

var menuOwner

enum state {
	spellcast,
	item,
	close
}

func _ready():
	hide()

func _changeOwners(hero):
	hide()
	menuOwner = hero
	show()

func _on_attack_pressed() -> void:
	print("Attacking!")
	menuOwner._endTurn()


func _on_spellcast_pressed() -> void:
	print("WIZARD SHIT GO!")
	menuOwner._die()


func _on_item_pressed() -> void:
	print("Opening bag!")
	menuOwner._moveTurn(2)
