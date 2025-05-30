class_name GhostBody extends Polygon2D

@onready var left_eye: Polygon2D = $GhostBody/LeftEye
@onready var right_eye: Polygon2D = $GhostBody/RightEye
@onready var mouth: Polygon2D = $GhostBody/Mouth
@onready var right_pupil: Polygon2D = $GhostBody/RightPupil
@onready var left_pupil: Polygon2D = $GhostBody/LeftPupil

@onready var animation_player: AnimationPlayer = $AnimationPlayer
