class_name RedGhost extends Ghost

func _ready() -> void:
	pass

func recalculate_chase_target():
	var pac_data: Dictionary[String, Vector2i] = GameManager.get_pacman_data() 
	var pac_grid_pos: Vector2i = pac_data["grid_pos"]
	
	target_grid_position = pac_grid_pos
