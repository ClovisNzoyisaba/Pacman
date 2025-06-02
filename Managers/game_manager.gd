extends Node 

var mapManager: MapManager
var musicManager: MusicManager
var objectManager: ObjectManager
var transitionManager: TransitionManager
var uiManager: UIManager

func setup(tile_map_layer: TileMapLayer, root: Node, main_menu: MainMenu, hud: HUD, animation_player: AnimationPlayer, sounds: Dictionary[String, AudioStreamPlayer]) -> void:
	mapManager = MapManager.new(tile_map_layer)
	musicManager = MusicManager.new(sounds)
	objectManager = ObjectManager.new(root)
	transitionManager = TransitionManager.new(animation_player)
	uiManager = UIManager.new(main_menu, hud)
	connect_all()

const STATE = TransitionManager.STATE
	
func get_map_data():
	return {
		"graph": mapManager.graph,
		"tilemap": mapManager.tile_map_layer
	}

func get_stat_data():
	return {
		"score": uiManager.score,
		"lives": uiManager.lives
	}

func get_pacman_data() -> Dictionary[String,Vector2i]:
	
	if objectManager.pacman == null:
		push_error("pacman was not created")
	
	return {
		"curr_dir" : objectManager.pacman.curr_direction,
		"grid_pos" : objectManager.pacman.grid_position
	}
	
func get_ghost_data(name: String) -> Dictionary[String, Vector2i]:
	var ghost: Ghost = objectManager.ghost_map.get(name) as Ghost
	
	if ghost == null:
		push_error(name + " is not a valid ghost name.")
		
	return { 
		"curr_dir": ghost.curr_direction, 
		"grid_pos": ghost.grid_position
	}

func get_state() -> TransitionManager.STATE:
	return transitionManager.curr_state 

func start_new_game():
	play_sound("start_button")
	uiManager.reset_lives()
	uiManager.reset_score()
	uiManager.disable_button()
	uiManager.update_message("GAME START")
	create_entities()
	reset_pellets()
	transitionManager.transition_menu_to_game()

func start_new_level():
	play_sound("victory")
	uiManager.update_message("NEW LEVEL")
	 # this could also be emitted when a level is restarted, so this is neccessary to distinguish between the two
	transitionManager.mid_transition_to_game.connect(reset_pellets, CONNECT_ONE_SHOT)
	transitionManager.transition_game_to_new_game()

func restart_curr_level():
	uiManager.update_message("RESTART LEVEL")
	transitionManager.transition_game_to_new_game()

func end_game():
	uiManager.update_message("END GAME")
	transitionManager.transition_game_to_menu()

func handle_player_death():
	uiManager.update_lives()
	if uiManager.get_lives() < 1:
		play_sound("game_over")
		end_game()
	else:
		play_sound("player_death")
		restart_curr_level()
		
func create_entities():
	objectManager.clear_objects()
	objectManager.create_pacman()
	objectManager.create_ghosts()

func reset_pellets():
	objectManager.reset_pellets()

func play_sound(sound_name: String):
	musicManager.play_sound(sound_name)
	
func connect_all():
	objectManager.call_deferred("connect_pellet_signals")
	
	objectManager.awarded_points.connect(uiManager.update_score)
	objectManager.pacman_died.connect(handle_player_death)
	objectManager.player_won.connect(start_new_level)
	
	transitionManager.transitioned_to_menu.connect(uiManager.enable_button)
	
	transitionManager.mid_transition_to_game.connect(create_entities)
	transitionManager.mid_transition_to_game.connect(uiManager.update_message.bind("GAME START"))
	
	uiManager.start_button.pressed.connect(start_new_game)

	
	
	
	
