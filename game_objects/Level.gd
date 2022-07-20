extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ENEMIES = {
	zombie =  preload("res://game_objects/entities/enemies/Zombie.tscn")
}

onready var rng := RandomNumberGenerator.new()

signal game_over
signal current_score

# Called when the node enters the scene tree for the first time.
func _ready():
	$Spawn/Timer.wait_time = rng.randf_range(.5, 1)
	$Spawn/Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	emit_signal("current_score", str($Player.score))

func _on_Player_shoot(bullet):
	bullet.position = $Player.position \
	 + $Player/GunSprite.offset.rotated($Player/GunSprite.rotation)
	bullet.connect("kill_score", self, "_on_enemy_killed")
	add_child(bullet)


func _on_VerticalLimit_body_entered(body):
	print(body.name)
	if body.name == "Player":
		$Player.die()
	if body.is_in_group("enemies"):
		body.queue_free()
		print("enemy data removed")


func _on_Timer_timeout():
	var enemy
	match rng.randi_range(0, 1):
		0: pass
		1:
			enemy = ENEMIES.zombie.instance()
			if rng.randi_range(0, 1) == 1:
				enemy.position = $Spawn/Zombie/LeftPoint.position
				enemy.velocity = Vector2(1, 0)
			else:
				enemy.position = $Spawn/Zombie/RightPoint.position
				enemy.velocity = Vector2(-1, 0)
			$Spawn/Timer.wait_time = rng.randf_range(0.2, 0.8)

	if enemy != null:
		enemy.add_to_group("enemies")
		add_child(enemy)


func _on_Player_dead():
	emit_signal("game_over")
