extends ColorRect

var resume_highlighted: bool
var highlighted_label_settings = LabelSettings.new()
var default_label_settings = LabelSettings.new()

var hud_node: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud_node = get_parent().get_node("HUD")
	
	resume_highlighted = true
	
	highlighted_label_settings.font_color = Color(0.01, 0.917, 1.0, 1.0)
	highlighted_label_settings.font_size = 36
	default_label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
	default_label_settings.font_size = 36
	
	$VBoxContainer/ResumeLabel.label_settings = highlighted_label_settings
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		$PauseSound.play()
		
		if get_tree().paused:
			show()
			if hud_node is Node:
				hud_node.hide()
		else:
			hide()
			if hud_node is Node:
				hud_node.show()

	if get_tree().paused:
		if event.is_action_pressed("move_up") or event.is_action_pressed("move_down"):
			resume_highlighted = !resume_highlighted
						
			if resume_highlighted:
				$VBoxContainer/ResumeLabel.label_settings = highlighted_label_settings
				$VBoxContainer/ResumeLabel.text = "- Resume -"
				$VBoxContainer/QuitLabel.label_settings = default_label_settings
				$VBoxContainer/QuitLabel.text = "Quit"
			else:
				$VBoxContainer/ResumeLabel.label_settings = default_label_settings
				$VBoxContainer/ResumeLabel.text = "Resume"
				$VBoxContainer/QuitLabel.label_settings = highlighted_label_settings
				$VBoxContainer/QuitLabel.text = "- Quit -"
		if event.is_action_pressed("enter"):
			if resume_highlighted:
				get_tree().paused = false
				hide()
			else:
				get_tree().quit()


func _on_blink_timer_timeout() -> void:
	$PauseLabel.visible = not $PauseLabel.visible # Replace with function body.
