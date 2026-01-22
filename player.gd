extends RigidBody2D

signal player_death

var player_is_alive := true
var move_speed: float = 500.0
var jump_power: float = 250.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass


func _physics_process(_delta: float) -> void:
	var input_direction: Vector2 = Vector2.ZERO
	
	if player_is_alive:
		if Input.is_action_pressed("move_left"):
			input_direction.x -= 1
		if Input.is_action_pressed("move_right"):
			input_direction.x += 1
		
		# Orient player sprite
		if input_direction.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = input_direction.x > 0
			$BasketSprite.flip_h = input_direction.x > 0
		
		# Apply horizontal force for movement
		apply_central_force(input_direction * move_speed)
	
		# Determine whether to animate sprite based on horizondal velocity
		if linear_velocity.x < 25 and linear_velocity.x > -25:
			$AnimatedSprite2D.stop()
		else:
			$AnimatedSprite2D.play()
		
		# Apply impulse for jumping
		if Input.is_action_just_pressed("jump") and is_on_floor():
			$JumpSound.play()
			apply_central_impulse(Vector2(0, -jump_power))
	else:
		linear_velocity.x = 0
		
# Determine whether player is on the floor using vertical velocity	
func is_on_floor() -> bool:
	# This is a basic example; more robust floor detection might be needed
	# depending on your game's complexity.
	# One common method is to use a RayCast2D or Area2D below the player.
	# For simplicity, this example assumes the player is on the floor if
	# its linear velocity in y is near zero and it's not currently jumping up.
	return linear_velocity.y < 5 and linear_velocity.y > -5 


func _integrate_forces(state):
	# Keep the character from moving off screen
	var screen_size = get_viewport_rect().size
	var body_size = get_node("CollisionShape2D").shape.extents * 2 # Assuming a RectangleShape2D, adjust for other shapes
	
	var clamped_position = state.transform.origin
	clamped_position.x = clamp(clamped_position.x, body_size.x / 2, screen_size.x - body_size.x / 2)
	clamped_position.y = clamp(clamped_position.y, body_size.y / 2, screen_size.y - body_size.y / 2)

	# If the position was clamped, adjust the velocity to prevent it from moving further out of bounds
	if clamped_position != state.transform.origin:
		state.linear_velocity = (clamped_position - state.transform.origin) / state.step


func play_death_animation():
	player_is_alive = false
	$BasketSprite.hide()
	$AnimatedSprite2D.animation = "game_over"
	$AnimatedSprite2D.play()
	$DeathSound.play()
	await $AnimatedSprite2D.animation_finished
	player_death.emit()
