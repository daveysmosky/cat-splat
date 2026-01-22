extends CanvasLayer

# Notifies 'Main' node that the button has been pressed.
signal new_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_start()
	$StartButton.hide()
	$SplashScreenTimer.start()
	$SplashPath.initialize_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_splash_screen_timer_timeout() -> void:
	$StartButton.show()


func _on_start_button_pressed() -> void:
	$MenuVibes.stop()
	await get_tree().create_timer(0.5).timeout
	if visible: 
		hide()
		new_game.emit()


func initialize_start():
	show()
	$MenuVibes.play(0.6)
