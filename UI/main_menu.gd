class_name MainMenu extends CanvasLayer

@onready var title: Label = $"../MainMenu2/VBoxContainer/HBoxContainer/Title"
@onready var button: Button = $"../MainMenu2/VBoxContainer/HBoxContainer2/Button"

signal transition_animation_done

func play_transition(intro: bool):
	var tween: Tween = get_tree().create_tween()
	var final_val: float = 0.0 if intro else 1.0
	#tween.tween_property(transition_screen,"shader_parameter/progress", final_val, 2)	
	#tween.tween_callback(func(): transition_done.emit())
