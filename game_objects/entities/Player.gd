extends KinematicBody2D


# Declare member variables here. Examples:
signal shoot
var velocity := Vector2(0, 0)
var jump = 2
var speed := 400
var aim
const FRICTION := 0.09
const ACCELERATION := 0.02
const BULLET := preload("res://game_objects/entities/bullet/Bullet.tscn")
enum Aim { UP, DOWN, LEFT, RIGHT }

# Called when the node enters the scene tree for the first time.
func _ready():
	aim = Aim.RIGHT


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("player_shoot") \
	and $FireRateTimer.is_stopped():
		shoot()

func _physics_process(delta):
	# velocity.x = 0
	
	# check player state
	if is_on_floor():
		velocity.y = 0
		jump = 2
	else:
		velocity.y += 25
	
	if is_on_wall():
		velocity.x = 0
	
	if is_on_ceiling():
		position.y += 1
		velocity.y = 0
	
	# check movement input
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
	if abs(x_dir) > 0:
		velocity.x = lerp(velocity.x, x_dir, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION)
		$PlayerSprite.animation = "idle"
	
	if velocity.y < 0:
		$PlayerSprite.animation = "jump"
	
	$DebugDisplayVelocity.text = \
	str(Vector2(int(velocity.x), int(velocity.y)))
	move_and_slide(velocity, Vector2(0, -1))

# custom functions

func shoot():
	
	# create bullet
	$GunSprite.visible = true
	var bullet = BULLET.instance()
	bullet.rotation = $GunSprite.rotation
	bullet.type = "normal"
	emit_signal("shoot", bullet)
	
	# start firerate timer
	$FireRateTimer.start()


func _on_FireRateTimer_timeout():
	$GunSprite.visible = false
