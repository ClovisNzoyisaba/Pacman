class_name Pacman extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var graph: Dictionary = {}
var tilemap: TileMapLayer

var curr_direction: Vector2i
var next_direction: Vector2i
var grid_position: Vector2i

var speed: int = 150

var warped: bool = false

func _ready() -> void:
	update_player_grid_position()
	animation_player.play("chomp")

	
func _physics_process(delta: float) -> void:
	if GameManager.get_state() != GameManager.STATE.GAME:
		return
		
	update_player_grid_position()
	handle_input()

	if is_aligned_to_grid():
		if can_move(next_direction):
			self.rotation = (Vector2(next_direction).angle())
			position = tilemap.map_to_local(tilemap.local_to_map(position))
			curr_direction = next_direction
			next_direction = Vector2.ZERO
			
		elif not can_move(curr_direction):
			velocity = Vector2.ZERO
			return
	
	velocity = curr_direction * speed
	
	check_warp()
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
	var check_pos: Vector2i = grid_position + Vector2i(dir)
	var ghost_house_entrance: Vector2 = Vector2(330,370)
	return graph[grid_position].has(check_pos) and check_pos != tilemap.local_to_map(ghost_house_entrance)

func is_aligned_to_grid() -> bool:
	var pixel_position = position
	var grid_pos = tilemap.map_to_local(tilemap.local_to_map(pixel_position))
	return pixel_position.distance_to(grid_pos) < 4.0  # 1px leeway

func update_player_grid_position():
	grid_position = tilemap.local_to_map(position)
		
func setup(position: Vector2, curr_direction: Vector2):
	var mapData = GameManager.get_map_data()
	graph = mapData.get("graph")
	tilemap = mapData.get("tilemap")
	
	self.position = tilemap.map_to_local(tilemap.local_to_map(position))
	self.curr_direction = curr_direction	
	self.next_direction = Vector2.ZERO

func check_warp() -> void:
	if grid_position == tilemap.local_to_map(Vector2(-16,400)) and curr_direction == Vector2i.LEFT:
		position = tilemap.local_to_map(tilemap.map_to_local(Vector2(680,400)))
		
	elif grid_position == tilemap.local_to_map(Vector2(680,400)) and curr_direction == Vector2i.RIGHT:
		position = tilemap.local_to_map(tilemap.map_to_local(Vector2(-16,400)))
		
		
