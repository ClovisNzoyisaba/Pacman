class_name UIManager extends Node

# ui manager updates score, lives, button presses (needs HUD and main menu references)
var main_menu: MainMenu
var hud: HUD
var start_button: Button
var score: int = 0
var lives: int = 3

func _init(main_menu: MainMenu, hud: HUD) -> void:
	self.main_menu = main_menu
	self.hud = hud
	self.start_button = main_menu.button
	
func update_lives() -> void:
	self.lives -= 1
	hud.set_lives(lives)
	
func update_score(score: int) -> void:
	hud.set_score(score)

func update_message(message: String) -> void:
	hud.set_message(message)

func reset_score() -> void:
	score = 0
	hud.reset_score()

func reset_lives() -> void:
	lives = 3
	hud.reset_lives()

func get_lives() -> int:
	return lives

func enable_button():
	main_menu.enable_button()

func disable_button():
	main_menu.disable_button()
