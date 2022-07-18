extends Control
class_name Hud
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hud_message
enum Msg {GAME_PAUSE, GAME_RESTART, GAME_CONTINUE, GAME_EXIT}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match $GameOverTimer.is_stopped():
		true:
			$GameOverLabel.hide()
		false:
			$GameOverLabel.show()


func _on_PauseButton_pressed():
	$PauseDialog.popup()
	emit_signal("hud_message", Msg.GAME_PAUSE)
	


func _on_RestartButton_pressed():
	emit_signal("hud_message", Msg.GAME_RESTART)


func _on_MenuButton_pressed():
	emit_signal("hud_message", Msg.GAME_EXIT)


func _on_PauseDialog_popup_hide():
	emit_signal("hud_message", Msg.GAME_CONTINUE)


func _on_GameOverTimer_timeout():
	emit_signal("hud_message", Msg.GAME_EXIT)
