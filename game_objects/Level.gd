extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal game_over
signal current_score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	emit_signal("current_score", str($Player.score))

func _on_Player_shoot(bullet):
	bullet.position = $Player.position \
	 + $Player/GunSprite.offset.rotated($Player/GunSprite.rotation)
	add_child(bullet)


func _on_VerticalLimit_body_entered(body):
	print(body.name)
	if body.name == "Player":
		# $Player.queue_free()
		emit_signal("game_over")
