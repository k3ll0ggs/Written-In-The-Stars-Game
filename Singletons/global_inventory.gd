extends Node

var jsonSaveFile = "res://JSON Saves/Inventory.JSON"
var inst = JSON.new()
var inventory = {}

func _ready(): #I'm treating ready as game_start() for now
	_loadInvInfo()

func _loadInvInfo(): #this should be called upon game start
#resources
	var file = FileAccess.open(jsonSaveFile, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var parse_result = inst.parse(content)
		if parse_result == OK:
			inventory = inst.data
		else:
			print("Error parsing JSON:", inst.error_string)
	else:
		print("Save file not found.")
	
func _saveInvInfo(): #this should ONLY be called at save points
	#now we'd save all of the character data to the save file
	var json_string = JSON.stringify(inventory, "\t") # Indent with tabs for readability
	var file = FileAccess.open(jsonSaveFile, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Game data saved successfully!")
	else:
		print("Error saving game data.")
	pass
