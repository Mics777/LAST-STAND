extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity : Vector2
export var speed := 300

# Called when the node enters the scene tree for the first time.
func _ready():
	# velocity = Vector2(1, 0)
	if velocity.x < 0:
		$AnimSprite.flip_h = true
	velocity.x *= speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	
	# ensures that entity doesn't fall too quickly upon falling off
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += 12
	
	move_and_slide(velocity, Vector2(0, -1))
	for col_i in get_slide_count():
		var collision = get_slide_collision(col_i)
		if collision.collider.name == "Bullet":
			queue_free()
