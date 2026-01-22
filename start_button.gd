extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextBlinkTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_text_blink_timer_timeout() -> void:
	visible = not visible # Replace with function body.


func _input(event) -> void:
	if event.is_action_pressed("ui_accept"): # "ui_accept" is the default action for Enter key
		hide()
		$StartSound.play()
		pressed.emit()
