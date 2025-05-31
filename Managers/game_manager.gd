extends Node 

var mapManager: MapManager
var musicManager: MusicManager
var objectManager: ObjectManager
var transitionManager: TransitionManager
var uiManager: UIManager

func setup(tile_map_layer: TileMapLayer, root: Node, main_menu: MainMenu, hud: HUD) -> void:
	mapManager = MapManager.new(tile_map_layer)
	musicManager = MusicManager.new()
	objectManager = ObjectManager.new(root)
	transitionManager = TransitionManager.new(main_menu, hud)
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
	reset()
	create_entities()

func end_game(won: bool):
	transitionManager.transition_to_menu(won)

func reset():
	uiManager.reset()
	objectManager.clear_objects()

func restart():
	uiManager.update_lives()
	reset()
	
		
func create_entities():
	objectManager.create_pacman()
	objectManager.create_ghosts()
	objectManager.reset_pellets()

func connect_all():
	objectManager.call_deferred("connect_pellet_signals")
	objectManager.awarded_points.connect(uiManager.update_score)
	objectManager.pacman_died.connect(end_game.bind(false))
	objectManager.player_won.connect(end_game.bind(true))
	transitionManager.transitioned_to_menu.connect(start_new_game)
	
	
	
	
