extends Node2D

@export var level_scene: PackedScene = preload("res://level.tscn")
var logo_scene: PackedScene = preload("res://logo_screen.tscn")
var start_menu_scene: PackedScene = preload("res://start_menu.tscn")

var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var logo = logo_scene.instantiate()
	logo.logo_done.connect(_on_logo_scene_logo_done)
	add_child(logo)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func new_game():
	# Clear any remaining mobs & player
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("player", "queue_free")
	get_tree().call_group("level", "queue_free")
	
	# Instantiate level -> not using while Level is an explicit child of Main
	var level = level_scene.instantiate()
	level.game_over.connect(game_over)
	add_child(level)
	
	# Re-add pause menu to the end of the tree so it draws on top
	var pause_menu = $PauseMenu
	remove_child(pause_menu)
	add_child(pause_menu)
	
	# This needs to be moved into level.gd -> level signals HUD directly?
	score = 0
	$HUD.show()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")


# There is no way to reach this at the moment.
func game_over():
	$Level.hide()
	$HUD.hide()
	$StartMenu.initialize_start()


func _on_logo_scene_logo_done():
	var start_menu = start_menu_scene.instantiate()
	start_menu.new_game.connect(new_game)
	add_child(start_menu)
