extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ENEMIES = {
	zombie =  preload("res://game_objects/entities/enemies/Zombie.tscn"),
	slime = preload("res://game_objects/entities/enemies/Slime.tscn")
}
enum SPAWN_LOCATION_CLASS { POINT, PATH }

onready var rng := RandomNumberGenerator.new()

signal game_over
signal current_score

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
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

func _on_enemy_killed(score):
	$Player.score += score
	


func _on_Timer_timeout():
	var enemy
	match rng.randi_range(0, 2):
		0: pass
		1:
			enemy = ENEMIES.zombie.instance()
			enemy.position = \
			set_enemy_spawn_point(SPAWN_LOCATION_CLASS.POINT)
			enemy.velocity.x = set_enemy_spawn_dir(enemy)
		2: 
			enemy = ENEMIES.slime.instance()
			enemy.position = \
			set_enemy_spawn_point(SPAWN_LOCATION_CLASS.POINT)
			enemy.direction = set_enemy_spawn_dir(enemy)
#		1:
#			enemy = ENEMIES.zombie.instance()
#			if rng.randi_range(0, 1) == 1:
#				enemy.position = $Spawn/Zombie/LeftPoint.position
#				enemy.velocity = Vector2(1, 0)
#			else:
#				enemy.position = $Spawn/Zombie/RightPoint.position
#				enemy.velocity = Vector2(-1, 0)
#			$Spawn/Timer.wait_time = rng.randf_range(0.4, 0.8)
#		2:
#			enemy = ENEMIES.slime.instance()
#			if rng.randi_range(0, 1) == 1:
#				enemy.position = $Spawn/Slime/LeftPoint.position
#				enemy.direction = 1
#			else:
#				enemy.position = $Spawn/Slime/RightPoint.position
#				enemy.direction = -1
#			$Spawn/Timer.wait_time = rng.randf_range(0.5, 1.3)\
	if enemy != null:
		enemy.add_to_group("enemies")
		add_child(enemy)
		$Spawn/Timer.wait_time = rng.randf_range(0.2, 0.8)

# set default direction
func set_enemy_spawn_dir(enemy) -> int:
	var center_x = (get_viewport_rect().size / 2).x
	if center_x > enemy.position.x:
		return 1
	else: return -1
	

# pick a random spawnpoint
func set_enemy_spawn_point(spawn_location: int) -> Vector2:
	match spawn_location:
		SPAWN_LOCATION_CLASS.POINT:
			var points := [
				$Spawn/Points/UpperLeft,
				$Spawn/Points/UpperRight,
				$Spawn/Points/LowerLeft,
				$Spawn/Points/LowerRight
			]
			return points[rng.randi_range(0, len(points) - 1)].position
		_: return Vector2(0, 0)

func _on_Player_dead():
	emit_signal("game_over")


func _on_Void_body_entered(body):
	print(body.name)
	if body.name == "Player":
		$Player.die()
	if body.is_in_group("enemies"):
		body.queue_free()
		print("enemy data removed")
