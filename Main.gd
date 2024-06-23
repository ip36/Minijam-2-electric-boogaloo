extends Node
var enemiesalive = 0
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in get_tree().get_nodes_in_group("killontouch"):
		enemiesalive += 1
	for item in get_tree().get_nodes_in_group("killontouch"):
		item.connect("body_entered", Callable(get_node("Player"), "die").bind(item))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _collect_coin(body, node):
	pass


func _on_level_child_entered_tree(node):
	node.connect("body_entered", self._collect_coin.bind(node))
