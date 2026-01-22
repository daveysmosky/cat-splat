extends Node2D

var mob_scene_white: PackedScene = preload("res://mob_white.tscn")
var mob_scene_grey: PackedScene = preload("res://mob_grey.tscn")
var mob_scene_orange: PackedScene = preload("res://mob_orange.tscn")
var player_scene: PackedScene = preload("res://player.tscn")

signal game_over

const max_score = 5 # Maximum player score; currently maxes out at 5

var player
var score
var health = 3 # Player health; maxes out at 5 hearts currently
var hud_node: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to HUD
	hud_node = get_parent().get_node("HUD")
	
	# Make sure game over screen is hidden
	$GameOverScreen.hide()
		
	# Initialize score & start delay timer & music
	$LevelMusic.play()
	$StartTimer.start()
	score = 0
	
	# Create a new instance of the player scene.
	player = player_scene.instantiate()
	
	var start_position = $PlayerStartPosition
	player.position = start_position.position
	
	add_child(player)
	
	# Connect player_death signal to Level
	player.player_death.connect(_on_player_death)
	
	# Update Health
	if hud_node is Node:
		hud_node.update_health(health)

	# Move foreground to bottom of tree so it is drawn on top
	var foreground = $LevelForeground
	remove_child(foreground)
	add_child(foreground)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Begin gameplay loop after short delay
func _on_start_timer_timeout() -> void:
	$MobTimer.start()


# Generate new mob each time the mob timer expires
func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob_scene = [ mob_scene_white, mob_scene_grey, mob_scene_orange ].pick_random()
	var mob = mob_scene.instantiate()
		
	# Set the mob's position to the random location.
	mob.position = [ $MobStartPosition1.position, $MobStartPosition2.position, $MobStartPosition3.position ].pick_random()
	
	# Randomize mob spawn position around selected MobStartPosition
	var offset_x = randi_range(-50, 50)
	var mob_spawn_offset = Vector2(offset_x, 0)
	
	mob.position += mob_spawn_offset
	
	# Spawn the mob by adding it to the Level scene.
	add_child(mob)
	
	# Connect cat_caught & cat_slat in  Mob signal to function in Level
	mob.cat_caught.connect(_on_mob_cat_caught)
	mob.cat_splat.connect(_on_mob_cat_splat)

func _on_player_death() -> void:
		# This is really inefficient.
		await get_tree().create_timer(2.5).timeout # Pause for 2.5 seconds to let Game Over message display
		
		# Show don't do drugs message and pause
		player.hide()
		$DoDrugs.show()
		await get_tree().create_timer(2.5).timeout
		
		$GameOverScreen.reset()
		game_over.emit()


func _on_mob_cat_splat() -> void:
	if health > 0:
		$SplatSound.play()
		health -= 1
	
		# Report player health if level has been instantiated with a HUD sibling
		if hud_node is Node:
			hud_node.update_health(health)
	
		if health <= 0:
			# All of this should be a separate function?
			# Stop level music playing
			$LevelMusic.stop()
			# Stop mobs from generating
			$MobTimer.stop()
			await $SplatSound.finished
			get_tree().call_group("mobs", "queue_free")
		
			# Prepare viewport & initiate player death animation; will emit player_death signal when done.
			if hud_node is Node:
				hud_node.hide()
		
			$LevelForeground.hide()
		
			$GameOverScreen.game_over()
			player.play_death_animation()


# Updates the score when a cat is caught
func _on_mob_cat_caught() -> void:
	score += 1
	$MeowSound.play()
	
	# Report score if level has been instantiated with a HUD sibling
	if hud_node is Node:
		hud_node.update_score(score)

	# Run game over/you win loop
	if score == max_score:
		# Stop level music playing
		$LevelMusic.stop()
		# Stop mobs from generating
		$MobTimer.stop()
		get_tree().call_group("mobs", "queue_free")
		
		# Prepare viewport & initiate player death animation; will emit player_death signal when done.
		if hud_node is Node:
			hud_node.hide()
		
		$LevelForeground.hide()
		
		$GameOverScreen.game_over("You Win!", true)
		player.play_death_animation()
