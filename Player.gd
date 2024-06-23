extends CharacterBody2D

@export_range(0, 10.0) var move_speed_modifier: float = 1
@export_range(0, 10.0) var jump_height_modifier: float = 1
var move_speed = 400
var jump_height = 800
@export var gravity: int = 2000

@export_range(0, 1.0) var friction: float = 0.95
@export_range(0, 1.0) var acceleration: float = 0.95
@export_range(0, 5.0) var gravity_divisor: float = 2
@export var coyote_time: int = 10
@export var jump_buffer: int = 10

var coyote_timer = 0
var jump_buffer_timer = 0
var increased_gravity = false
var lookingdirection = 1
var jumps = 0
var grappling = false
var grappletarget
const graaplespeed = 500
var hovertime = 1
var armor = false
var nocontrols = false
var movingtimer = 0
var seperateupgradeslist = []
var currentlooking
var list = []
var savedir = 1
var shrunk = false

func _ready():
	seperateupgradeslist = Upgradesmanager.upgradeshave.duplicate()
	if Upgradesmanager.upgradeshave["Hover"]:
		$ProgressBar.visible = true
	if Upgradesmanager.upgradeshave["Armor"]:
		armor = true
	if Upgradesmanager.upgradeshave["Gun"]:
		$Node2D.visible = true
	for i in range(3):
		currentlooking = seperateupgradeslist.keys().find(seperateupgradeslist.find_key(true))
		list.append(currentlooking)
		seperateupgradeslist.erase(seperateupgradeslist[seperateupgradeslist.keys()[currentlooking]])
		seperateupgradeslist[seperateupgradeslist.keys()[currentlooking]] = false
	$AnimatedSprite2D2.frame = list[0]
	$AnimatedSprite2D3.frame = list[1]
	$AnimatedSprite2D4.frame = list[2]

func get_horizontal_movement():
	if nocontrols:
		velocity.x = 0
		return
	var dir = 0
	if Input.is_action_pressed("move_right"):
		dir += 1
	if Input.is_action_pressed("move_left"):
		dir -= 1
	if dir != 0:
		lookingdirection = dir
		velocity.x = lerpf(velocity.x, dir * move_speed * move_speed_modifier, acceleration)
		$AnimatedSprite2D.play()
		savedir = dir
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x)*dir
	else:
		velocity.x = lerpf(velocity.x, 0, friction)
		$AnimatedSprite2D.frame = 4
		$AnimatedSprite2D.pause()

func can_jump():
	if jumps == 1 and not is_on_floor():
		return true
	return is_on_floor() or coyote_timer != 0

func wants_to_jump():
	if jump_buffer_timer != 0:
		jump_buffer_timer = 0
		increased_gravity = false
		return true
	return false

func jump():
	velocity.y = 0
	velocity.y -= jump_height * jump_height_modifier
	increased_gravity = false

func apply_gravity(delta):
	if increased_gravity:
		velocity.y += gravity * gravity_divisor * delta
	else:
		velocity.y += gravity * delta


func check_coyote_timer():
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= 1
	if coyote_timer < 0:
		coyote_timer = 0

func check_jump_buffer():
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer
	else:
		jump_buffer_timer -= 1
	if jump_buffer_timer < 0:
		jump_buffer_timer = 0

func _physics_process(delta):
	if movingtimer > 0:
		movingtimer -= delta
	else:
		nocontrols = false
		$AnimatedSprite2D.visible = true
		$Sprite2D.visible = false
	if not Input.is_action_pressed("hover") and Upgradesmanager.upgradeshave["Hover"] and hovertime < 1:
		if hovertime + delta/2 >= 1:
			hovertime = 1
			$ProgressBar.value = hovertime
		else:
			hovertime += delta/2
			$ProgressBar.value = hovertime
	if Input.is_action_just_pressed("shrink") and Upgradesmanager.upgradeshave["Shrink"] and not $RayCast2D.is_colliding():
		if not shrunk:
			$AnimatedSprite2D.scale.x = savedir 
			$AnimatedSprite2D.scale.y = 1 
			$CollisionShape2D.scale = Vector2(1, 1)
			shrunk = true
		else:
			$AnimatedSprite2D.scale.x = savedir * 2
			$AnimatedSprite2D.scale.y = 2
			$CollisionShape2D.scale = Vector2(2, 2)
			shrunk = false
	if is_on_floor() and Upgradesmanager.upgradeshave["Double Jump"]:
		jumps = 1
	get_horizontal_movement()
	check_coyote_timer()
	check_jump_buffer()
	if Input.is_action_just_released("jump") and velocity.y < -100:
		increased_gravity = true
	elif velocity.y > 0:
		increased_gravity = true
	apply_gravity(delta)
	if can_jump() and wants_to_jump() and not nocontrols:
		if not is_on_floor():
			jumps = 0
		coyote_timer = 0
		jump_buffer_timer = 0
		jump()
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	set_floor_stop_on_slope_enabled(true)
	if Input.is_action_pressed("hover") and hovertime > 0 and Upgradesmanager.upgradeshave["Hover"] and not is_on_floor() and not nocontrols:
		$CPUParticles2D.emitting = true
		velocity.y = -50
		hovertime -= delta
		$ProgressBar.value = hovertime
	if Input.is_action_just_released("hover"):
		$CPUParticles2D.emitting = false
	if not grappling:
		move_and_slide()
	velocity = velocity
	if grappling:
		position = position.move_toward(grappletarget, graaplespeed*delta)
		if position.distance_to(grappletarget) < 50:
			grappling = false
			jump()

func die(body, item):
	if body == self and not nocontrols:
		if armor:
			armor = false
			if position.x - item.position.x != abs(position.x - item.position.x):
				position.x -= 20
			else:
				position.x += 20
			nocontrols = true
			movingtimer = 1.5
			$AnimatedSprite2D.visible = false
			$Sprite2D.visible = true
			$CPUParticles2D2.emitting = true
		else:
			get_tree().call_deferred("reload_current_scene")

func grapple(pos):
	grappling = true
	grappletarget = pos
