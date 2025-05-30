class_name HUD extends CanvasLayer
 
@onready var score_num: Label = $VBoxContainer/HBoxContainer/ScoreNum

@onready var life_1: TextureRect = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Life1
@onready var life_2: TextureRect = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Life2
@onready var life_3: TextureRect = $VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/Life3

@onready var transition_screen: ColorRect = $TransitionScreen

signal transition_animation_done

func set_score(score: int) -> void:
	score_num.text = str(int(score_num.text) + score)

func set_lives(count: int) -> void:
	life_1.visible = count >= 1
	life_2.visible = count >= 2
	life_3.visible = count >= 3

func reset():
	score_num.text = str(0)
	life_1.visible = true
	life_2.visible = true
	life_3.visible = true
