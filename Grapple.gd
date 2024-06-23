extends Area2D
const speed = 1000
var dir = 1
var startposition
var turned = false
var player
var firstframe = true
var moving

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	$RayCast2D.add_exception(player)
	for i in get_tree().get_nodes_in_group("coins"):
		$RayCast2D.add_exception(i)
	connect("body_entered", hitwall)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RayCast2D.target_position = to_local(player.global_position)
	$Line2D.points[0] = to_local(player.global_position)
	$Line2D2.points[0] = to_local(player.global_position)
	if firstframe:
		startposition = position
	position += transform.x * speed * delta * dir
	if firstframe:
		if position.x > startposition.x:
			moving = "right"
		else:
			moving = "left"
		firstframe = false
	if abs(startposition.x-position.x) > 300 and not turned:
		dir *= -1
		turned = true
	if moving == "right" and position.x < startposition.x:
		self.queue_free()
	elif moving == "left" and position.x > startposition.x:
		self.queue_free()

func hitwall(body):
	if body is TileMap and not $RayCast2D.is_colliding():
		player.grapple(position)
	if (body != get_parent().get_node("Player") and not body.is_in_group("coin")) or (body == get_parent().get_node("Player") and turned):
		self.queue_free()

