class_name MainMenu extends CanvasLayer

@onready var transition_screen: ColorRect = $TransitionScreen
@onready var title: Label = $VBoxContainer/HBoxContainer/Title
@onready var button: Button = $VBoxContainer/HBoxContainer2/Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var message: Label = $message

func disable_button():
	button.disabled = true

func enable_button():
	button.disabled = false

func play_transition(intro: bool):
	if intro:
		message.text = "GAME START"
		animation_player.play("transition")
	else:
		animation_player.play_backwards("transition")
