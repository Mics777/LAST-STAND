extends KinematicBody2D


# Declare member variables here. Examples:
signal shoot
signal show_score
signal dead
var velocity := Vector2(0, 0)

const FRICTION := 0.09
const ACCELERATION := 0.02
const BULLET := preload("res://game_objects/entities/bullet/Bullet.tscn")
var aim
enum Aim { UP, DOWN, LEFT, RIGHT }
onready var jump  := 2
onready var speed := 400
onready var score := 0
onready var alive := true
# Called when the node enters the scene tree for the first time.
func _ready():
	aim = Aim.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# used for one time event i.e. shoot
func _input(event):
	if event.is_action_pressed("player_shoot") \
	and $FireRateTimer.is_stopped():
		shoot()

func _physics_process(delta):
	# ensures player doesn't fall off too quickly 
	# when off the platform
	if is_on_floor():
		velocity.y = 0
		jump = 2
	else:
		velocity.y += 25
	
	# ensures player doesn't stick to walls
	if is_on_wall():
		velocity.x = 0
	
	# make so that player doesn't stick to the ceiling
	if is_on_ceiling():
		position.y += 1
		velocity.y = 0
	
	# if player touches enemy
	for col_i in get_slide_count():
		var collision = get_slide_collision(col_i)
		if collision.collider.is_in_group("enemies"):
			die()
	
	# check aim and movement input
	var x_dir = 0 # x direction
	if Input.is_action_pressed("player_move_left"):
		x_dir -= 1
		aim = Aim.LEFT
		$PlayerSprite.animation = "run"
		$PlayerSprite.flip_h = true
	if Input.is_action_pressed("player_move_right"):
		x_dir += 1
		aim = Aim.RIGHT
		$PlayerSprite.animation = "run"
		$PlayerSprite.flip_h = false
	if Input.is_action_pressed("player_aim_down"):
		aim = Aim.DOWN
	if Input.is_action_pressed("player_aim_up"):
		aim = Aim.UP
	if Input.is_action_just_pressed("player_move_jump") \
	and jump > 0:
		velocity.y = -600
		jump -= 1
	
	x_dir *= speed
	
	# match aim
	match aim:
		Aim.LEFT:
			$GunSprite.flip_v = true
			$GunSprite.rotation = PI
		Aim.RIGHT:
			$GunSprite.flip_v = false
			$GunSprite.rotation = 0
		Aim.UP:
			$GunSprite.flip_v = false
			$GunSprite.rotation = PI*1.5
		Aim.DOWN:
			$GunSprite.flip_v = false
			$GunSprite.rotation = PI/2
	
	# update player state
	# code allows for smooth acceleration/deceleration of player movement
	if abs(x_dir) > 0:
		velocity.x = lerp(velocity.x, x_dir, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION)
		$PlayerSprite.animation = "idle"
	
	if velocity.y < 0:
		$PlayerSprite.animation = "jump"
	
	# emit signal to output score to Main
	emit_signal("show_score", str(score))
	
	# debug-specific code: disabled on release
	$DebugDisplayVelocity.text = \
	str(Vector2(int(velocity.x), int(velocity.y)))
	
	# signal game if dead
	if not alive:
		emit_signal("dead")
	
	# move player
	move_and_slide(velocity, Vector2(0, -1))

# custom functions

# run upon player death
func die():
	hide()
	$Shape.disabled = true
	alive = false

func shoot():
	
	# create bullet
	$GunSprite.visible = true
	var bullet = BULLET.instance()
	bullet.rotation = $GunSprite.rotation
	bullet.type = "normal"
	emit_signal("shoot", bullet)
	
	# start firerate timer
	$FireRateTimer.start()

# displays gun and allows the player to fire 
func _on_FireRateTimer_timeout():
	$GunSprite.visible = false

# add points if still alive
func _on_SurviveTickTimer_timeout():
	if alive: score += 5


func _on_Hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		die()
