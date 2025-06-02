class_name OrangeGhost extends RedGhost

func recalculate_chase_target():
	var pac_data: Dictionary[String, Vector2i] = GameManager.get_pacman_data() 
	var pac_grid_pos: Vector2i = pac_data["grid_pos"]
	super.recalculate_chase_target()
	var dist = manhattan_distance(grid_position, pac_grid_pos)
	if dist < 8:
		scatter()
	
func manhattan_distance(a: Vector2i, b: Vector2i) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)	
