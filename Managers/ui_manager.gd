class_name UIManager extends Node

# ui manager updates score, lives, button presses (needs HUD and main menu references)
var main_menu: MainMenu
var hud: HUD
var score: int
var lives: int

func _init(main_menu: MainMenu, hud: HUD) -> void:
	self.main_menu = main_menu
	self.hud = hud
	
func update_lives() -> void:
	pass

func update_score(score: int) -> void:
	pass

func update_main_menu_screen() -> void:
	pass

func update_game_screen() -> void:
	pass

func play_transition_screen() -> void:
	pass

func modulate_message() -> void:
	pass
	
func reset_modulation() -> void:
	pass
