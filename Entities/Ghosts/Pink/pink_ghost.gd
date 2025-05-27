class_name PinkGhost extends Ghost

# pink chooses a position that is some tiles ahead of pacman
func recalculate_chase_target():
	var pac_data: Dictionary[String, Vector2i] = GameManager.get_pacman_data() 
	var pac_grid_pos: Vector2i = pac_data["grid_pos"]
	var pac_curr_dir: Vector2i = pac_data["curr_dir"]
	var target_tile: Vector2i = pac_grid_pos
	
	var tiles_ahead = 4
	
	target_tile += pac_curr_dir * tiles_ahead
	
	target_grid_position = target_tile
