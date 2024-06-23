extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", ouch)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ouch(body):
	if body == get_parent().get_parent().get_node("Player"):
		get_parent().get_parent().get_node("Player").die(body, self)
