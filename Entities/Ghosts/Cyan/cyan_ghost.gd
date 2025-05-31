class_name CyanGhost extends Ghost

func recalculate_chase_target():
	var red_ghost_data: Dictionary[String, Vector2i] =  GameManager.get_ghost_data("red")
	var pac_data: Dictionary[String, Vector2i] = GameManager.get_pacman_data() 
	
	var red_ghost_grid_pos: Vector2i = red_ghost_data["grid_pos"]
	var pac_grid_pos: Vector2i = pac_data["grid_pos"]
	var pac_curr_dir: Vector2i = pac_data["curr_dir"]
	var target_tile: Vector2i = pac_grid_pos
	
	var tiles_ahead = 2 
	
	target_tile += Vector2i(pac_curr_dir) * tiles_ahead
	
	var v: Vector2 = tilemap.map_to_local(target_tile) - tilemap.map_to_local(red_ghost_grid_pos)
	
	var v2: Vector2 = v * 2
	
	var v3: Vector2 = tilemap.map_to_local(red_ghost_grid_pos) + v2
	
	target_grid_position = tilemap.local_to_map(v3)
	
	
	
