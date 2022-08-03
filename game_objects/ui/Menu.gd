extends Control
signal playButtonPressed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# callback functions,
# all three send signals upon any event from the ui
func _on_QuitButton_pressed():
	get_tree().quit()


func _on_HelpButton_pressed():
	$HelpDialog.popup()


func _on_PlayButton_pressed():
	emit_signal("playButtonPressed")
