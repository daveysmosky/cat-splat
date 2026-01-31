extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func game_over(message := "Game Over!") -> void:
	$GameOverMessage.text = message
	show()
	$BlinkTimer.start()

func reset() -> void:
	$BlinkTimer.stop()
	
	hide()


func _on_blink_timer_timeout() -> void:
	$GameOverMessage.visible = !$GameOverMessage.visible
