class_name Game extends Node

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var hud: HUD = $Hud

func _ready() -> void:
	GameManager.setup(tile_map_layer, self, null, hud)
	GameManager.objectManager.create_pacman(Vector2(305, 112), Vector2i(0,1))
	GameManager.objectManager.create_red_ghost(Vector2(300, 300), Vector2(625, 48))
	GameManager.objectManager.create_pink_ghost(Vector2(330,300), Vector2(48,48))
	GameManager.objectManager.create_orange_ghost(Vector2(360, 300), Vector2(625,622))
	GameManager.objectManager.create_cyan_ghost(Vector2(336, 272), Vector2(49,626))
	
