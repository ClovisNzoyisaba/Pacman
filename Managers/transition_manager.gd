class_name TransitionManager extends Node

enum STATE {MENU, GAME, TRANSITION}
var curr_state: STATE
var main_menu: MainMenu

signal transitioned_to_menu
signal transitioned_to_game

func _init(main_menu: MainMenu, hud: HUD) -> void:
	self.main_menu = main_menu
	main_menu.button.pressed.connect(transition_to_game)
	main_menu.animation_player.animation_finished.connect(handle_transition_end)

func change_state():
	match curr_state:
		STATE.MENU:
			curr_state = STATE.GAME
		_:
			curr_state = STATE.MENU
			
func transition_to_game():
	main_menu.disable_button()
	main_menu.play_transition(true)
	
func transition_to_menu(won: bool):
	if won: main_menu.message.text = "YOU WON"
	else: main_menu.message.text = "YOU DIED"
	main_menu.play_transition(false)

func handle_transition_end(animation_name: String):
	change_state()
	match curr_state:
		STATE.MENU:
			main_menu.enable_button()
			transitioned_to_menu.emit()
		_:
			transitioned_to_game.emit()
