extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", collect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func collect(body):
	if body.is_in_group("Player"):
		get_tree().call_deferred("change_scene_to_file", "res://" + str(int(str(get_tree().current_scene.name)) + 1) + ".tscn")
