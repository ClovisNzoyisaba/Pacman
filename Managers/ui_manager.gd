class_name UIManager extends Node

# ui manager updates score, lives, button presses (needs HUD and main menu references)
var main_menu: MainMenu
var hud: HUD
var score: int = 0
var lives: int = 3

func _init(main_menu: MainMenu, hud: HUD) -> void:
	self.main_menu = main_menu
	self.hud = hud
	
func update_lives() -> void:
	self.lives -= 1
	hud.set_lives(lives)
	
func update_score(score: int) -> void:
	hud.set_score(score)
	
func reset() -> void:
	score = 0
	lives = 3
	hud.reset()
