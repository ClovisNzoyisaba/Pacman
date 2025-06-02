class_name MainMenu extends CanvasLayer

@onready var transition_screen: ColorRect = $TransitionScreen
@onready var title: Label = $VBoxContainer/HBoxContainer/Title
@onready var button: Button = $VBoxContainer/HBoxContainer2/Button

func disable_button():
	button.disabled = true

func enable_button():
	button.disabled = false
