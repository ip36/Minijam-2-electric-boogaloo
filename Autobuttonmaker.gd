@tool
extends Container
@export var lvlcount = 9
@export var buttontemplate : Button
@export var giveimages : bool
@export var inputmap : bool
var slotstaken = 0
var images = [
"Gun.png",
"Ammo.png",
"Boots.png",
"Armor.png",
"Potion_Double_Jumping.png",
"Hovercraft.png",
"Lasso.png",
"Potion_Morphing.png"]
var tooltips = [
"It's a gun. You need bullets to use it.
You need either those two upgrades
or the stomping boots to kill all
the enemies.",
"You need these to use the gun.",
"Jump on an enemy's head to kill it.",
"This hat allows you to survive
one hit from an enemy. It only
works once and recharges
between levels or after dying.",
"Jump an additional time in the.
air by pressing the jump key
again. NOTE that YOU NEED AT LEAST
ONE MOVEMENT UPGRADE TO GET TO
THE GOAL IN EACH LEVEL.",
"Gravity is for suckers. Propel
yourself upward while in the air.
has limited fuel.",
"Allows you to quickly travel a short
distance by pulling yourself. You gain
some height at the end of your grapple,
allowing you to scale walls with it.",
"allows you to turn into a smaller
version of you to move through small
gaps which lead to more challenging
areas. For skilled players only. Has
no practical use for completing levels."]
var upgrades = [
	"Gun",
	"Ammunition",
	"Stomping boots",
	"Armor",
	"Double Jump",
	"Hover",
	"Grappling hook",
	"Shrink",
]
var slots = [true, true, true]
var controls = ["move_left", "move_right", "jump", "hover", "gun", "shrink", "hook"]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(lvlcount):
		var tmpbutt : Button = buttontemplate.duplicate()
		get_child(0).add_child(tmpbutt)
		tmpbutt.text = str(i+1)
		tmpbutt.visible = true
		if inputmap:
			tmpbutt.InputToRebind = controls[i]
		if giveimages:
			Upgradesmanager.upgradeshave = {
	"Gun" : false,
	"Ammunition" : false,
	"Stomping boots" : false,
	"Armor" : false,
	"Double Jump" : false,
	"Hover" : false,
	"Grappling hook" : false,
	"Shrink" : false,
}
			tmpbutt.icon = load(images[i])
			tmpbutt.get_node("Label").text = tooltips[i]
			tmpbutt.myupgrade = upgrades[i]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
