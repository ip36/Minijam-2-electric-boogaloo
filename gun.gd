extends Node2D
var shootcooldown = 0
var shootcooldownmax = 0.5
var grapplecooldown


# Called when the node enters the scene tree for the first time.
func _ready():
	var projectile = load("res://Projectile.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = get_parent().lookingdirection * 10
	get_child(0).scale.x = get_parent().lookingdirection * -1
	if shootcooldown > 0:
		shootcooldown -= delta
	if Input.is_action_pressed("gun") and shootcooldown <= 0 and Upgradesmanager.upgradeshave["Gun"] and Upgradesmanager.upgradeshave["Ammunition"]:
		var projectile = load("res://Projectile.tscn")
		var newprojectile = projectile.instantiate()
		get_parent().get_parent().add_child(newprojectile)
		newprojectile.position = get_parent().position
		newprojectile.visible = true
		newprojectile.get_child(0).set_deferred("disabled", false)
		newprojectile.player = get_parent()
		newprojectile.dir = get_parent().lookingdirection
		newprojectile.get_node("Sprite2D").scale.x = newprojectile.dir
		shootcooldown = shootcooldownmax
	if Input.is_action_pressed("lasso") and shootcooldown <= 0 and Upgradesmanager.upgradeshave["Grappling hook"]:
		var projectile = load("res://Grapple.tscn")
		var newprojectile = projectile.instantiate()
		get_parent().get_parent().add_child(newprojectile)
		newprojectile.position = get_parent().position
		newprojectile.visible = true
		newprojectile.get_child(0).set_deferred("disabled", false)
		newprojectile.player = get_parent()
		newprojectile.dir = get_parent().lookingdirection
		newprojectile.get_node("Sprite2D").scale.x = newprojectile.dir
		shootcooldown = shootcooldownmax
