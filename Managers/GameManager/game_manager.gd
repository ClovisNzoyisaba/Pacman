extends Node

# map manager updates graph

# ui manager updates score, lives, button presses (needs HUD and main menu references)

# transition manager updates states, ends one game state and begins another also sends signal to ui manager to play a transition animation 

var mapManager: MapManager
var musicManager: MusicManager
var objectManager: ObjectManager
var transitionManager: TransitionManager
var uiManager: UIManager

func setup(tile_map_layer: TileMapLayer, root: Node, main_menu: MainMenu, hud: HUD) -> void:
	mapManager = MapManager.new(tile_map_layer)
	musicManager = MusicManager.new()
	objectManager = ObjectManager.new(root)
	print(getTileMap())
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
