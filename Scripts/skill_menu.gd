extends VBoxContainer


const button = preload("res://Scenes/skill_button.tscn")
var passed = {}

func _ready():
	$".".hide()


#this makes the menu for the skills
var menuOpen = 0 #we need to make sure we dont create more menus, use this as a lock
func _makeOptions(passed):
	if menuOpen == 0:
		for i in passed:
			var inst = button.instantiate()
			inst._learnSelf(passed[i])
			$".".add_child(inst)
		$".".show()
		menuOpen = 1


func _deleteOptions():
	#delete all children of self
	for j in self.get_children():
		self.remove_child(j)
		j.queue_free()
	menuOpen = 0
