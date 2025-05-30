class_name MainMenu extends CanvasLayer

@onready var transition_screen: ColorRect = $TransitionScreen
@onready var title: Label = $VBoxContainer/HBoxContainer/Title
@onready var button: Button = $VBoxContainer/HBoxContainer2/Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func disable_button():
	button.disabled = true

func enable_button():
	button.disabled = false

func play_transition(intro: bool):
	if intro:
		animation_player.play("transition")
	else:
		animation_player.play_backwards("transition")
	
#func transition1(intro: bool):
	#var tween: Tween = get_tree().create_tween()
	#var final_val: float = 0.0 if intro else 1.0
	#tween.set_parallel()
	#tween.tween_property(title, "modulate:a", final_val, 1)	
	#tween.tween_property(button, "modulate:a", final_val, 1)
	#tween.finished.connect(transition2.bind(intro))
	#
#func transition2(intro: bool):
	#var tween: Tween = get_tree().create_tween()
	#var final_val: float = 0.0 if intro else 1.0
	#tween.tween_property(transition_screen.material,"shader_parameter/progress", final_val, 2)	
	#tween.finished.connect(func(): transition_animation_done.emit())
#
#func transitionTest(intro: bool):
	#pass
	#
#func transition(intro: bool):
	#if intro:
		#transition1(intro)
