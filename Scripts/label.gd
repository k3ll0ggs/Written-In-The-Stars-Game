extends Label

@onready var charui = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charui.variable = $".".text
	charui.test()
	pass # Replace with function body.
