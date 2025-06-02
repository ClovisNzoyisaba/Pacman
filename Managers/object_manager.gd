class_name ObjectManager extends Node

const CYAN_GHOST = preload("res://Entities/Ghosts/Cyan/CyanGhost.tscn")
const ORANGE_GHOST = preload("res://Entities/Ghosts/Orange/OrangeGhost.tscn")
const PINK_GHOST = preload("res://Entities/Ghosts/Pink/PinkGhost.tscn")
const RED_GHOST = preload("res://Entities/Ghosts/Red/RedGhost.tscn")
const PACMAN = preload("res://Entities/Pacman/Pacman.tscn")

var GHOST_SCENES: Dictionary = {
	"red": RED_GHOST,
	"pink": PINK_GHOST,
	"orange": ORANGE_GHOST,
	"cyan": CYAN_GHOST
}

var ghost_map: Dictionary = {}

var pacman: Pacman

var root: Game

var pellets_collected: int = 0
var pellets_available: int = 202

signal pacman_died
signal awarded_points(points: int)
signal player_won

func _init(root: Game) -> void:
	self.root = root
	
func create_ghosts(
	ghost_types: Array[String] = ["red", "pink", "orange", "cyan"],
	spawn_positions: Array[Vector2] = [Vector2(300, 400), Vector2(330, 400), Vector2(360, 400), Vector2(336, 368)],
	scatter_positions: Array[Vector2] = [Vector2(-35, 25), Vector2(745,10), Vector2(745,835), Vector2(-100,835)]
) -> void:
	
	assert(
		ghost_types.size() == spawn_positions.size() and ghost_types.size() == scatter_positions.size(),
		"create_ghosts(): size mismatch"
	)

	for i in ghost_types.size():
		var ghost_name = ghost_types[i]
		var ghost_scene: PackedScene = GHOST_SCENES.get(ghost_name)
		assert(ghost_scene != null, "No ghost scene for: %s" % ghost_name)

		var ghost: Ghost = ghost_scene.instantiate() as Ghost
		ghost.setup(spawn_positions[i], scatter_positions[i])
		ghost.connect("body_entered", handle_ghost_body_entered.bind(ghost))
		root.add_child(ghost)
	
		ghost_map[ghost_name] = ghost
	
func create_pacman(position: Vector2 = Vector2(338,593), direction: Vector2i = Vector2i(0,1)) -> void:
	pacman = PACMAN.instantiate()
	pacman.setup(position, direction)
	root.add_child(pacman)

func create_objects() -> void:
	create_ghosts()
	create_pacman()
	
func clear_objects() -> void:
	for ghost in ghost_map.values():
		ghost.queue_free()
	ghost_map.clear()
	if pacman:
		pacman.queue_free()
	
func connect_pellet_signals() -> void:
	for small_pellet in root.get_tree().get_nodes_in_group("SmallPelletGroup"):
		small_pellet.connect("body_entered", handle_small_pellet_collection.bind(small_pellet), CONNECT_ONE_SHOT)
		
	for power_pellet in root.get_tree().get_nodes_in_group("BigPelletGroup"):
		power_pellet.connect("body_entered", handle_power_pellet_collection.bind(power_pellet), CONNECT_ONE_SHOT)

func reset_pellets() -> void:
	for pellet in root.get_tree().get_nodes_in_group("SmallPelletGroup"):
		pellet.pellet.visible = true
		
	for pellet in root.get_tree().get_nodes_in_group("BigPelletGroup"):
		pellet.pellet.visible = true
	
	pellets_collected = 0
	
	connect_pellet_signals()

func handle_small_pellet_collection(body, small_pellet: Node2D) -> void:
	GameManager.play_sound("pellet")
	awarded_points.emit(100)
	small_pellet.pellet.visible = false
	pellets_collected += 1
	if pellets_collected == pellets_available:
		disable_ghost_signals()
		player_won.emit()
		pellets_collected = 0

func handle_power_pellet_collection(body, power_pellet: Node2D) -> void:
	GameManager.play_sound("power_pellet")
	awarded_points.emit(500)
	power_pellet.pellet.visible = false
	frighten_all_ghosts()
	pellets_collected += 1
	if pellets_collected == pellets_available:
		disable_ghost_signals()
		player_won.emit()
		pellets_collected = 0


func frighten_all_ghosts():
	for ghost in root.get_tree().get_nodes_in_group("Ghosts"):
		ghost = ghost as Ghost
		if !ghost.is_traversing_house() and !ghost.is_returning():
			ghost.frighten()

func handle_ghost_body_entered(body, ghost: Ghost) -> void:
	match ghost.curr_ghost_state:
		ghost.GHOSTSTATE.RETURNING:
			pass
		ghost.GHOSTSTATE.HOUSETRAVERSAL:
			pass
		ghost.GHOSTSTATE.FRIGHTEND:
			handle_ghost_death(ghost)
		_:
			handle_pac_death()

func handle_ghost_death(ghost: Ghost):
	GameManager.play_sound("ghost_death")
	awarded_points.emit(1000)
	ghost.return_home()

func handle_pac_death():
	disable_ghost_signals()
	pacman_died.emit()

func disable_ghost_signals():
	for ghost in root.get_tree().get_nodes_in_group("Ghosts"):
		ghost = ghost as Ghost
		ghost.disconnect("body_entered", handle_ghost_body_entered)
		
