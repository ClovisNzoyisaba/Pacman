class_name Game extends Node

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var hud: HUD = $Hud

func _ready() -> void:
	GameManager.setup(tile_map_layer, self, null, hud)
	GameManager.objectManager.create_pacman(Vector2(305, 112), Vector2i(0,1))
	print(GameManager.get_pacman_grid_position())
	GameManager.objectManager.create_red_ghost(Vector2(430, 560))
