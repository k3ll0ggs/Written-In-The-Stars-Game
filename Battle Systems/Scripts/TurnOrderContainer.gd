extends Control

#GPT followed me through most of this

@export var spacing: float = 10.0
@export var animation_speed: float = 18.0

var dragged: Control = null
var drag_offset: Vector2



func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	layout_instant()

func _process(delta):
	if dragged:
		update_drag()
		update_reorder()
	layout_animated(delta)



# -------------------------------------------------
# Drag Handling
# -------------------------------------------------

func start_drag(item: Control):
	dragged = item #declares the object we want to grab as "dragged" so we can do stuff with it
	# Store offset from mouse to item top-left
	drag_offset = dragged.position - get_local_mouse_position()
	item.z_index = 100 #this is to make the object being grabbed appear on top when dragging

func stop_drag():
	if dragged:
		dragged.z_index = 0 #put the object back in line with the others (put it down)
		dragged = null #when we're done dragging, we don't need to call it
	_organize()

func update_drag():
	if not dragged:
		return

	# Get mouse position relative to this Control
	var local_mouse = get_local_mouse_position()
	
	# Adjust by the original offset
	var local = local_mouse + drag_offset #drag ofset is how fast/slow the object moves I think

	# Clamp inside container
	#clamp is how we keep it in a straight line,  
	#we should change these depending on the container we put the turn order in
	local.x = clamp(local.x, 0, size.x - dragged.size.x)
	local.y = 0

	dragged.position = local



# -------------------------------------------------
# Reordering Logic
# -------------------------------------------------

func update_reorder():
	#I think this is just for making sure the mouse is dragging the center of the object
	var dragged_center = dragged.position.x + dragged.size.x * 0.5
	var new_index := 0

	for i in get_child_count():
		var child = get_child(i)
		if child == dragged:
			continue
#we only count the items that aren't being dragged ^


		var child_center = target_slot_position(i).x + child.size.x * 0.5

		if dragged_center > child_center:
			new_index += 1

	if dragged.get_index() != new_index:
		move_child(dragged, new_index)


# -------------------------------------------------
# Layout
# -------------------------------------------------

func layout_instant():
	var x := 0.0
	for child in get_children():
		child.position = Vector2(x, 0)
		x += child.size.x + spacing


#use this for moving around stuff without dragging
func layout_animated(delta):
	var x := 0.0

	for child in get_children():
		var target = Vector2(x, 0)

		if child != dragged:
			child.position = child.position.lerp(
				target,
				animation_speed * delta
			)

		x += child.size.x + spacing


#we should look at this to figure out how to force move icons around
func target_slot_position(index: int) -> Vector2:
	var x := 0.0
	for i in index:
		var child = get_child(i)
		x += child.size.x + spacing
	return Vector2(x, 0)


func _organize():
	for i in get_child_count():
		get_child(i).order = i #this should make all of the turns have their correct order


func _moveTurn(child, newIndex): #use this function for calling turn reorders on characters
	if newIndex >= get_child_count():
		newIndex = (get_child_count()-1)
	if newIndex < 0:
		newIndex = 0
	move_child(child, newIndex)
	_organize()
