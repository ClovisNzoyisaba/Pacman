class_name TransitionManager extends Node

enum STATE {MENU, GAME, TRANSITION}
var curr_state: STATE

var animation_player: AnimationPlayer

signal transitioned_to_menu
signal transitioned_to_game
signal mid_transition_to_game
signal started_transitioning_to_game
signal started_transitioning_to_menu

func _init(animation_player: AnimationPlayer) -> void:
	self.animation_player = animation_player
# Entry points
func transition_menu_to_game():
	curr_state = STATE.TRANSITION
	started_transitioning_to_game.emit()
	await play_animation_sequence([
		{ "name": "menu_fade", "forward": true },
		{ "name": "screen_wipe", "forward": true },
		{ "name": "word_slide", "forward": true },
	], false)
	change_state(STATE.GAME)

func transition_game_to_menu():
	curr_state = STATE.TRANSITION
	started_transitioning_to_menu.emit()
	await play_animation_sequence([
		{ "name": "word_slide", "forward": false },
		{ "name": "screen_wipe", "forward": false },
		{ "name": "menu_fade", "forward": false },
	], false)
	change_state(STATE.MENU)

func transition_game_to_new_game():
	curr_state = STATE.TRANSITION
	await play_animation_sequence([
		{ "name": "word_slide", "forward": false },
		{ "name": "screen_wipe", "forward": false },
		{ "name": "screen_wipe", "forward": true },
		{ "name": "word_slide", "forward": true },
	], true)
	change_state(STATE.GAME)

# The coroutine-based animation chain
func play_animation_sequence(sequence: Array[Dictionary], emit_mid_animation: bool) -> void:
	for item in sequence:
		var ani_name: String = item["name"]
		var forward: bool = item["forward"]
		if forward:
			animation_player.play(ani_name)
		else:
			animation_player.play_backwards(ani_name)
	
		await animation_player.animation_finished
		
		if emit_mid_animation and ani_name == "screen_wipe" and !forward:
			mid_transition_to_game.emit()

# Update state and optionally do more
func change_state(new_state: STATE):
	curr_state = new_state
	match new_state:
		STATE.MENU:
			transitioned_to_menu.emit()
		STATE.GAME:
			transitioned_to_game.emit()
		STATE.TRANSITION:
			pass
