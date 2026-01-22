extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func show_message(text):
	$Message.text = text
	$MessageTimer.start()
	
	for i in range(3):
		$Message.show()
		await $MessageTimer.timeout 
		$Message.hide()
		await $MessageTimer.timeout 


func update_score(score):
	match score:
		0:
			$ScoreCats/ScoreCat1.hide()
			$ScoreCats/ScoreCat2.hide()
			$ScoreCats/ScoreCat3.hide()
			$ScoreCats/ScoreCat4.hide()
			$ScoreCats/ScoreCat5.hide()
		1: 
			$ScoreCats/ScoreCat1.show()
			$ScoreCats/ScoreCat2.hide()
			$ScoreCats/ScoreCat3.hide()
			$ScoreCats/ScoreCat4.hide()
			$ScoreCats/ScoreCat5.hide()
		2:
			$ScoreCats/ScoreCat1.show()
			$ScoreCats/ScoreCat2.show()
			$ScoreCats/ScoreCat3.hide()
			$ScoreCats/ScoreCat4.hide()
			$ScoreCats/ScoreCat5.hide()
		3:
			$ScoreCats/ScoreCat1.show()
			$ScoreCats/ScoreCat2.show()
			$ScoreCats/ScoreCat3.show()
			$ScoreCats/ScoreCat4.hide()
			$ScoreCats/ScoreCat5.hide()
		4:
			$ScoreCats/ScoreCat1.show()
			$ScoreCats/ScoreCat2.show()
			$ScoreCats/ScoreCat3.show()
			$ScoreCats/ScoreCat4.show()
			$ScoreCats/ScoreCat5.hide()
		_:
			$ScoreCats/ScoreCat1.show()
			$ScoreCats/ScoreCat2.show()
			$ScoreCats/ScoreCat3.show()
			$ScoreCats/ScoreCat4.show()
			$ScoreCats/ScoreCat5.show()
	
	
	
func update_health(health):
	# This section can be improved; maybe use TextureProgress node?
	match health:
		1:
			$Hearts/Heart1.show()
			$Hearts/Heart2.hide()
			$Hearts/Heart3.hide()
			$Hearts/Heart4.hide()
			$Hearts/Heart5.hide()
		2:
			$Hearts/Heart1.show()
			$Hearts/Heart2.show()
			$Hearts/Heart3.hide()
			$Hearts/Heart4.hide()
			$Hearts/Heart5.hide()
		3:
			$Hearts/Heart1.show()
			$Hearts/Heart2.show()
			$Hearts/Heart3.show()
			$Hearts/Heart4.hide()
			$Hearts/Heart5.hide()
		4:
			$Hearts/Heart1.show()
			$Hearts/Heart2.show()
			$Hearts/Heart3.show()
			$Hearts/Heart4.show()
			$Hearts/Heart5.hide()
		_:
			$Hearts/Heart1.show()
			$Hearts/Heart2.show()
			$Hearts/Heart3.show()
			$Hearts/Heart4.show()
			$Hearts/Heart5.show()
