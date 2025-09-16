extends TextureRect

var hero = "0"
var heroID = "0"
var savedID = "0"
@onready var maxHP = $"MarginContainer/HP Label Container/HP Max Label"
@onready var curHP = $"MarginContainer/HP Label Container/HP Current Label"
@onready var maxSP = $"MarginContainer2/SP Label Container/SP Max Label"
@onready var curSP = $"MarginContainer2/SP Label Container/SP Current Label"

func _connect(heroID):
	savedID = heroID
	savedID.corrUI = self
	_update()

func _update():
	#maybe change the bar progress and THEN change the label text off of it?
	$"Health Bar".max_value = savedID.health
	$"Health Bar".value = savedID.currentHealth
	$"MarginContainer/HP Label Container/HP Max Label".text = str(savedID.health)
	$"MarginContainer/HP Label Container/HP Current Label".text = str(savedID.currentHealth)

	$"Mana Bar".max_value = savedID.mana
	$"Mana Bar".value = savedID.currentMana
	$"MarginContainer2/SP Label Container/SP Max Label".text = str(savedID.mana)
	$"MarginContainer2/SP Label Container/SP Current Label".text = str(savedID.currentMana)
