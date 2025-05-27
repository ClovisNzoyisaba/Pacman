class_name HUD extends CanvasLayer
 
@onready var score_num: Label = $VBoxContainer/HBoxContainer/ScoreNum

@onready var life_1: TextureRect = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Life1
@onready var life_2: TextureRect = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Life2
@onready var life_3: TextureRect = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Life3

@onready var transition_screen: ColorRect = $TransitionScreen

signal transition_animation_done

func set_score(score: int) -> void:
	score_num.text = str(score)

func set_lives(count: int) -> void:
	life_1.visible = count >= 1
	life_2.visible = count >= 2
	life_3.visible = count >= 3

func play_transition(intro: bool):
	var tween: Tween = get_tree().create_tween()
	var final_val: float = 0.0 if intro else 1.0
	
	tween.tween_property(transition_screen,"shader_parameter/progress", final_val, 2)	
	tween.tween_callback(func(): transition_animation_done.emit())
