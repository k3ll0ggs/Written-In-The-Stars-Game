extends Node

var jsonSaveFile = "res://JSON Saves/Point.JSON"
var inst = JSON.new()
const Name = "Point"
var stats = {}

#temp, this is here because i need values for this data when it gets read by the game instantly. _onGameStart() is yet to be called anywhere in the code
var Health = 1
var CurrentHealth = 1
var Mana = 1
var CurrentMana = 1
var Attack = 1
var Defence = 1
var Magic = 1
var Weapon = "0"
var Armor = "0"
#temp


func _ready(): #I'm treating ready as game_start() for now
	_loadCharInfo()

func _loadCharInfo(): #this should be called upon game start
#resources
	var file = FileAccess.open(jsonSaveFile, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var parse_result = inst.parse(content)
		if parse_result == OK:
			stats = inst.data
		else:
			print("Error parsing JSON:", inst.error_string)
	else:
		print("Save file not found.")
	
#resources
	Health = stats["Health"]
	CurrentHealth = stats["Current Health"]
	Mana = stats["Mana"]
	CurrentMana = stats["Current Mana"]

#stats
	Attack = stats["Attack"]
	Defence = stats["Defence"]
	Magic = stats["Magic"]

#equipment
	Weapon = "0"
	Armor = "0"
	
	
	
	
func _saveCharInfo(): #this should ONLY be called at save points
	#now we'd save all of the character data to the save file
	var json_string = JSON.stringify(stats, "\t") # Indent with tabs for readability
	var file = FileAccess.open(jsonSaveFile, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Game data saved successfully!")
	else:
		print("Error saving game data.")
	pass
