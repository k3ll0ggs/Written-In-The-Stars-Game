extends Button

@onready var textBox = $"../../../FlavorText"
@onready var HPCost = $"../../../FlavorText/Line1"
@onready var SPCost = $"../../../FlavorText/Line2"
@onready var description = $"../../../FlavorText/Line3"

var save

# Called when the node enters the scene tree for the first time.
func _ready():
	textBox.hide()
	print("_ready()")
	pass # Replace with function body.

func _learnSelf(info):
	print("_learnSelf()")
	save = info
	self.text = save["Name"]


func _on_mouse_entered():
	print("Display Skill Description")
	textBox.show()
	if save["HP Cost"] > 0:
		HPCost.text = "HP Cost: " + str(save["HP Cost"])
	if save["SP Cost"] > 0.0:
		SPCost.text = "SP Cost: " + str(save["SP Cost"])
	description.text = save["Description"]

func _on_mouse_exited():
	print("Stop Displaying skill Description")
	textBox.hide()
	HPCost.text = ""
	SPCost.text = ""
	description.text = ""
