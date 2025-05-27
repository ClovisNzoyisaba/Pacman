class_name Game extends Node

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var hud: HUD = $Hud

func _ready() -> void:
	GameManager.setup(tile_map_layer, self, null, hud)
	make_connections()
	create_game_objects()

func _process(delta: float) -> void:
	pass
	
func create_game_objects() -> void:
	GameManager.create_entities()
	
func create_main_menu() -> void:
	GameManager.create_main_menu()

func make_connections() -> void:
	GameManager.connect_all()
	

	
	
	
	
func delete(node: Node):
	node.queue_free()
	
func delete_pellet():
	pass	
