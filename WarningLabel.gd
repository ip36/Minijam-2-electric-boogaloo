extends Label
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Button2".connect("nope", appear)
	$"../Button3".connect("nope", appear)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer > 0:
		timer -= delta
	else:
		visible = false

func appear():
	visible = true
	timer = 1
