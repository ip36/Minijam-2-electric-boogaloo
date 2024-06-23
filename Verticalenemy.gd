extends Area2D
var velocity = -150
var player
var fliptimer = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	$RayCast2D.add_exception(player)
	$Area2D.connect("body_entered", stomped)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fliptimer > 0:
		fliptimer -= delta
	else:
		fliptimer = 0.25
		scale.x *= -1
	if $RayCast2D.is_colliding():
		velocity *= -1
		$RayCast2D.target_position.y *= -1
	position.y += velocity * delta

func stomped(body):
	if body == player and Upgradesmanager.upgradeshave["Stomping boots"]:
		$CollisionShape2D.set_deferred("disabled", true)
		player.jump()
		get_parent().enemiesalive -= 1
		if get_parent().enemiesalive <= 0:
			get_tree().call_deferred("change_scene_to_file", "res://" + str(int(str(get_tree().current_scene.name)) + 1) + ".tscn")
		self.queue_free()
