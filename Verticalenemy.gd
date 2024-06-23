extends Area2D
var velocity = -150
var player
var fliptimer = 0.25
@export var shoot : bool
var shoottimer = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	$RayCast2D.add_exception(player)
	$Area2D.connect("body_entered", stomped)
	if shoot:
		$Node2D.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shoot:
		if shoottimer > 0:
			shoottimer -= delta
		else:
			shoottimer = 1
			var projectile = load("res://Projectile.tscn")
			var newprojectile = projectile.instantiate()
			get_parent().add_child(newprojectile)
			newprojectile.position = position
			newprojectile.visible = true
			newprojectile.get_child(0).set_deferred("disabled", false)
			newprojectile.player = get_parent().get_node("Player")
			newprojectile.dir = $Node2D.scale.x * -1
			newprojectile.add_to_group("killontouch")
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
