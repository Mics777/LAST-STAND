extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity := Vector2(0, 0)
var direction := 0
onready var speed := 200
onready var jump_vel := 200
onready var rng := RandomNumberGenerator.new()
# onready var jumping := true

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = direction * speed
	if direction < 0: $AnimatedSprite.flip_h = true
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if is_on_floor():
			velocity.x = 0
			if $JumpTimer.is_stopped():
				$JumpTimer.start()
	else:
		velocity.x = direction * speed
		velocity.y += 12
	
	move_and_slide(velocity, Vector2(0, -1))

func _on_JumpTimer_timeout():
	if is_on_floor():
		velocity.y = -(jump_vel + rng.randf_range(-100, 100))
