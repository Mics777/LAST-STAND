extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const LEVEL := preload("res://game_objects/Level.tscn")
const VERSTION := "v1.0.0"

onready var last_score    := 0
onready var highest_score := 0
var level
# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.visible = true
	$Menu/VersionLabel.text = "version " + VERSTION 
	update_score_history(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	$HUD.get_node("ScoreLabel").text = \
#	str(level.get_node("Player").score)

func _on_Menu_playButtonPressed():
	start_game()



func _on_HUD_hud_message(msg):
	match msg:
		Hud.Msg.GAME_EXIT:
			end_game()
			$HUD/PauseDialog.hide()
		Hud.Msg.GAME_CONTINUE:
			get_tree().paused = false
		Hud.Msg.GAME_PAUSE:
			get_tree().paused = true
		Hud.Msg.GAME_RESTART:
			end_game()
			start_game()
			$HUD/PauseDialog.hide()

func _get_player_score(score_str):
	$HUD/ScoreLabel.text = score_str

func _game_over():
	get_tree().paused = true
	$HUD/GameOverTimer.start()
	update_score_history(level.get_node("Player").score)

func start_game():
	get_tree().paused = false
	$Menu.visible = false
	$HUD.visible = true
	level = LEVEL.instance()
	level.connect("current_score", self, "_get_player_score")
	level.connect("game_over", self, "_game_over")
	add_child(level)

func end_game():
	level.queue_free()
	$HUD.visible = false
	$Menu.visible = true

func update_score_history(score: int):
	
	# update scores
	last_score = score
	if score > highest_score:
		highest_score = score
	
	# display scores
	$Menu/Progress/PrevScoreLabel.text \
	= "previous run: " + str(last_score)
	$Menu/Progress/HighScoreLabel.text \
	= "high score: " + str(highest_score)
