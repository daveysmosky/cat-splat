extends CanvasLayer

signal logo_done

enum LogoState { FADE_IN, FADE_OUT, GONE }

var current_state: LogoState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure logo is not visible
	$LogoSprite.self_modulate.a = 0.0
	current_state = LogoState.FADE_IN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Check to see if logo has already gone through fade-in/fade-out cycle
	if current_state == LogoState.GONE:
		await get_tree().create_timer(1.0).timeout
		queue_free()
		logo_done.emit()
	
	var logo = $LogoSprite
	
	# Start fading out once logo reaches 1.0 in alpha channel
	if logo.self_modulate.a >= 1:
		current_state = LogoState.FADE_OUT
	
	# Fade logo in or out
	match current_state:
		LogoState.FADE_IN:
			logo.self_modulate.a += 0.01
		LogoState.FADE_OUT:
			logo.self_modulate.a -= 0.01
	
	if logo.self_modulate.a <= 0:
		current_state = LogoState.GONE
