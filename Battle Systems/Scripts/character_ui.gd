extends Panel

var hero

@onready var maxHP = $"MarginContainer/HP Label Container/HP Max Label"
@onready var curHP = $"MarginContainer/HP Label Container/HP Current Label"
@onready var maxSP = $"MarginContainer2/SP Label Container/SP Max Label"
@onready var curSP = $"MarginContainer2/SP Label Container/SP Current Label"

func _update():
	#maybe change the bar progress and THEN change the label text off of it?
	$"Health Bar".max_value = hero.data["Max HP"]
	$"Health Bar".value = hero.data["Current HP"]
	$"MarginContainer/HP Label Container/HP Max Label".text = str(hero.data["Max HP"])
	$"MarginContainer/HP Label Container/HP Current Label".text = str(hero.data["Current HP"])

	$"Mana Bar".max_value = hero.data["Max SP"]
	$"Mana Bar".value = hero.data["Current SP"]
	$"MarginContainer2/SP Label Container/SP Max Label".text = str(hero.data["Max SP"])
	$"MarginContainer2/SP Label Container/SP Current Label".text = str(hero.data["Current SP"])
