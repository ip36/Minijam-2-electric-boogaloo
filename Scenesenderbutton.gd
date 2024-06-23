extends Button
@export var sendto : String
@export var overwrite : bool
@export var upgradescene : bool
@export var notefromitems : bool
signal nope

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clicked():
	if upgradescene:
		for i in $"../ScrollContainer".slots:
			if i is bool:
				emit_signal("nope")
				return
	if Upgradesmanager.camefromitems:
		Upgradesmanager.camefromitems = false
		get_tree().change_scene_to_file("res://Levelselect.tscn")
		return
	if notefromitems:
		Upgradesmanager.camefromitems = true
	if overwrite:
		get_tree().change_scene_to_file(sendto)
	else:
		get_tree().change_scene_to_file("res://" + text + ".tscn")
