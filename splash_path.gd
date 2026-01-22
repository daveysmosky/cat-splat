extends Path2D

@onready var path_follow = $PathFollow2D
@onready var splash_screen = get_node("PathFollow2D/SplashScreen")

var speed = 1.7 # Percent per second
var vertical_offset = -19.6 # Radian offset of SplashScreen on PathFollow2D
var scale_factor = 0.05 # Increase scale of SplashScreen by this amount each frame

var play_animation := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	splash_screen.animation = "flash"
	splash_screen.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	splash_screen.rotation = vertical_offset
	
	# Check if the sprite has reached the end of the path
	if path_follow.progress_ratio < 1.0 and play_animation:
		# Increase the progresss to move the sprite along the path
		path_follow.progress_ratio += speed * delta
		splash_screen.scale += Vector2(scale_factor, scale_factor)

func initialize_animation() -> void:
	play_animation = true
