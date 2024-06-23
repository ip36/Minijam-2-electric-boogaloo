extends Button
var firstframe = true
var myupgrade
var equipped = false
var buttonmaker
var startingindex
var atdsu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	startingindex = get_index()
	buttonmaker = get_parent().get_parent()
	connect("pressed", Igotclicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if atdsu:
		position = Vector2(688, 104)
	if firstframe:
		text = ""
		firstframe = false
func Igotclicked():
	if equipped:
		equipped = false
		self.reparent(get_parent().get_node("ScrollContainer/VBoxContainer"))
		position = Vector2(0, 0)
		get_child(0).visible = true
		get_parent().move_child(self, startingindex)
		buttonmaker.get_child(0).queue_sort()
		buttonmaker.slots[buttonmaker.slots.find(self)] = true
		Upgradesmanager.upgradeshave[myupgrade] = false
	elif buttonmaker.slots.find(true) != -1: 
		if buttonmaker.slots.find(true) == 0:
			equipped = true
			buttonmaker.slots[0] = self
			get_child(0).visible = false
			self.reparent(get_parent().get_parent().get_parent())
			position = Vector2(688, 60)
			Upgradesmanager.upgradeshave[myupgrade] = true
		elif buttonmaker.slots.find(true) == 1:
			equipped = true
			buttonmaker.slots[1] = self
			get_child(0).visible = false
			self.reparent(get_parent().get_parent().get_parent())
			position = Vector2(952, 60)
			Upgradesmanager.upgradeshave[myupgrade] = true
		elif buttonmaker.slots.find(true) == 2:
			equipped = true
			buttonmaker.slots[2] = self
			get_child(0).visible = false
			self.reparent(get_parent().get_parent().get_parent())
			position = Vector2(824, 220)
			Upgradesmanager.upgradeshave[myupgrade] = true
