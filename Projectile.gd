extends Area2D
var moving = false
const speed = 1000
var next_collision
var player
var fromplayer
var dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", hitsomething)
	connect("body_entered", hitwall)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta * dir

func hitsomething(area):
	if area.is_in_group("enemies"):
		get_parent().enemiesalive -= 1
		if get_parent().enemiesalive <= 0:
			get_tree().call_deferred("change_scene_to_file", "res://" + str(int(str(get_tree().current_scene.name)) + 1) + ".tscn")
		area.queue_free()
		self.queue_free()


func hitwall(body):
	if body != get_parent().get_node("Player") and not body.is_in_group("coin"):
		self.queue_free()
