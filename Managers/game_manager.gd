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
	transitionManager = TransitionManager.new()
	uiManager = UIManager.new(main_menu, hud)

func getGraph() -> Dictionary:
	return mapManager.graph

func getTileMap() -> TileMapLayer:
	return mapManager.tile_map_layer
	
func getScore() -> int:
	return uiManager.score
	
func getLives() -> int:
	return uiManager.lives

func getState() -> TransitionManager.STATE:
	return transitionManager.curr_state

func setState(state: TransitionManager.STATE):
	if transitionManager.curr_state != state:
		transitionManager.curr_state = state
	
func get_pacman_grid_position() -> Vector2i:
	return objectManager.pacman.grid_position

func get_pacman_curr_dir() -> Vector2i:
	return objectManager.pacman.curr_direction

func start_new_game():
	pass

func create_entities():
	objectManager.create_pacman()
	objectManager.create_ghosts()

func create_main_menu():
	objectManager.create_main_menu()

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

func connect_all():
	objectManager.call_deferred("connect_pellet_signals")
	#objectManager.connect_ghost_signals()
	#objectManager.connect_pacman_signals()
	
	
func getRedGhostDir():
	return objectManager.red_ghost.curr_direction

func getRedGhostGridPos():
	return objectManager.red_ghost.grid_position
