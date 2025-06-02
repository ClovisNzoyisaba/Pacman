class_name Game extends Node

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var hud: HUD = $HUD
@onready var main_menu: MainMenu = $MainMenu
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var pellet_sound: AudioStreamPlayer = $PelletSound
@onready var power_pellet_sound: AudioStreamPlayer = $PowerPelletSound
@onready var start_button_sound: AudioStreamPlayer = $StartButtonSound
@onready var ghost_death_sound: AudioStreamPlayer = $GhostDeathSound
@onready var player_death_sound: AudioStreamPlayer = $PlayerDeathSound
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound
@onready var victory_sound: AudioStreamPlayer = $VictorySound

func _ready() -> void:
	var sounds: Dictionary[String, AudioStreamPlayer] = {
		"pellet": pellet_sound,
		"power_pellet": power_pellet_sound,
		"start_button": start_button_sound,
		"ghost_death": ghost_death_sound,
		"player_death": player_death_sound,
		"game_over": game_over_sound,
		"victory": victory_sound
	}
		
	GameManager.setup(tile_map_layer, self, main_menu, hud, animation_player, sounds)
	
