extends Button

@onready var game = $"../../.."
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
