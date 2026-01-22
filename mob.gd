extends RigidBody2D

signal cat_caught
signal cat_splat

enum CatState { CLEANING, SITTING, WAITING, WALKING, FALLING }
enum CatFacing { LEFT = -1, RIGHT = 1 }

var current_state: CatState
var current_facing: CatFacing = CatFacing.LEFT
var move_speed := 500.0
var movement_vector := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set rotation to 0 when mob first created
	rotation = 0
	
	# Pick initial cat facing direction
	current_facing = [ CatFacing.LEFT, CatFacing.RIGHT ].pick_random()
	
	match current_facing:
		CatFacing.LEFT:
			$AnimatedSprite2D.flip_h = true
		CatFacing.RIGHT:
			$AnimatedSprite2D.flip_h = false
	
	# Pick initial cat state
	current_state = [ CatState.CLEANING, CatState.SITTING, CatState.WALKING, CatState.WALKING ].pick_random()
	
	match current_state:
		CatState.CLEANING:
			$AnimatedSprite2D.animation = "cleaning"
		CatState.SITTING:
			$AnimatedSprite2D.animation = "sitting"
		CatState.WALKING:
			$AnimatedSprite2D.animation = "walking"
	
	$AnimatedSprite2D.play()
	$FallTimer.start(randf_range(0.5, 2.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	# Orient mob in direction they are facing
	if linear_velocity.x != 0:
		$AnimatedSprite2D.flip_h = linear_velocity.x < 0


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body: Node):
	
	if body.is_in_group("floor"): 
		# Prevent Mob from not splattering if it falls from tree before FallTimer.timeout()
		$FallTimer.stop()
		
		# Remove player from mob collision mask so you can't pick up the blood splatter
		set_collision_mask_value(1, false)
		
		# Switch to "splatting" behavior
		$AnimatedSprite2D.animation = "splatting"
		
		cat_splat.emit()
	elif body.is_in_group("player"):
		# Prevent additional collisions
		$CollisionShape2D.set_deferred("disabled", true)
				
		# Perform "caught" behavior
		$AnimatedSprite2D.hide()
		
		cat_caught.emit()
		queue_free()
	
	# Initiate fall if mob hits a wal
	elif body.is_in_group("wall"):
		$FallTimer.stop()
		_on_fall_timer_timeout()


func _integrate_forces(state) -> void:
	# This function is called every physics frame.
	
	# Set the transform's rotation to 0 to override physics forces, then reset the angular velocity to prevent it from "sticking."
	state.transform = Transform2D(0, state.transform.origin)
	state.angular_velocity = 0
	
	match current_state:
		CatState.WALKING:
			movement_vector.x = 1 * current_facing
		_: # All other states
			movement_vector = Vector2.ZERO
			linear_velocity.x = 0
	
	apply_central_force(movement_vector * move_speed)


func _on_fall_timer_timeout() -> void:
	current_state = CatState.FALLING
	set_collision_mask_value(3, false)
	$AnimatedSprite2D.animation = "falling"
