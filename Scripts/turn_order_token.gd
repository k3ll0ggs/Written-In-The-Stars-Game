extends PanelContainer

var parentEntity = "0"
func _ready():
	await get_tree().create_timer(.001).timeout #only have a wait statement here because the hero class doesn't change character fast enough
	$TextureRect.texture = parentEntity.get_node("Icon").texture
