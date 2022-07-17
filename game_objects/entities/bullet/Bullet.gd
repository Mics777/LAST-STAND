extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction := Vector2(0, -1)
var speed := 800.0 # default speed
var type : String

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0.5, 0.5)
	$VariantSprite.animation = type
	$VariantSprite.rotate(PI/2)
	direction = direction.rotated(rotation + PI/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	move_and_slide(direction * speed)
