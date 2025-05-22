class_name Pacman extends CharacterBody2D

var graph: Dictionary = {}
var tilemap: TileMapLayer

var curr_direction: Vector2i
var next_direction: Vector2i
var grid_position: Vector2i

var speed: int = 150

func _ready() -> void:
	update_player_grid_position()
	
func _physics_process(delta: float) -> void:
	update_player_grid_position()
	handle_input()

	if is_aligned_to_grid():
		if can_move(next_direction):
			position = tilemap.map_to_local(tilemap.local_to_map(position))
			curr_direction = next_direction
			next_direction = Vector2.ZERO
		elif not can_move(curr_direction):
			velocity = Vector2.ZERO
			return
	
	velocity = curr_direction * speed
	move_and_slide()
	
func handle_input():
	if Input.is_action_just_pressed("ui_up"):
		next_direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		next_direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		next_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		next_direction = Vector2.RIGHT

func can_move(dir: Vector2) -> bool:
	var check_pos = grid_position + Vector2i(dir)
	return graph[grid_position].has(check_pos)

func is_aligned_to_grid() -> bool:
	var pixel_position = position
	var grid_pos = tilemap.map_to_local(tilemap.local_to_map(pixel_position))
	return pixel_position.distance_to(grid_pos) < 4.0  # 1px leeway

func update_player_grid_position():
	grid_position = tilemap.local_to_map(position)
	print(grid_position)
		
func setup(position: Vector2, curr_direction: Vector2):
	graph = GameManager.getGraph()
	tilemap = GameManager.getTileMap()
	self.position = tilemap.map_to_local(tilemap.local_to_map(position))
	self.curr_direction = curr_direction	
	self.next_direction = Vector2.ZERO
	
