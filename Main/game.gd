class_name Game extends Node

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var hud: HUD = $HUD
@onready var main_menu: MainMenu = $MainMenu


func _ready() -> void:
	GameManager.setup(tile_map_layer, self, main_menu, hud)
	GameManager.start_new_game()
