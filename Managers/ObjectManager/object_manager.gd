class_name ObjectManager extends Node

const CYAN_GHOST = preload("res://Entities/Ghosts/Cyan/CyanGhost.tscn")
const ORANGE_GHOST = preload("res://Entities/Ghosts/Orange/OrangeGhost.tscn")
const PINK_GHOST = preload("res://Entities/Ghosts/Pink/PinkGhost.tscn")
const RED_GHOST = preload("res://Entities/Ghosts/Red/RedGhost.tscn")
const PACMAN = preload("res://Entities/Pacman/Pacman.tscn")
const MAIN_MENU = preload("res://UI/MainMenu.tscn")

var cyan_ghost: CyanGhost
var pink_ghost: PinkGhost
var red_ghost: RedGhost
var orange_ghost: OrangeGhost
var pacman: Pacman
var main_menu: MainMenu

var root: Game

func _ready() -> void:
	pass

func _init(root: Game) -> void:
	self.root = root

func create_ghosts() -> void:
	cyan_ghost = CYAN_GHOST.instantiate()
	#pink_ghost = PINK_GHOST.instantiate()
	#red_ghost = RED_GHOST.instantiate()

func create_red_ghost(position: Vector2, scatter_position: Vector2) -> void:
	red_ghost = RED_GHOST.instantiate()
	red_ghost.setup(position, scatter_position)
	root.add_child(red_ghost)

func create_pink_ghost(position: Vector2, scatter_position: Vector2) -> void:
	pink_ghost = PINK_GHOST.instantiate()
	pink_ghost.setup(position, scatter_position)
	root.add_child(pink_ghost)
	
func create_orange_ghost(position: Vector2, scatter_position: Vector2) -> void:
	orange_ghost = ORANGE_GHOST.instantiate()
	orange_ghost.setup(position, scatter_position)
	root.add_child(orange_ghost)

func create_cyan_ghost(position: Vector2, scatter_position: Vector2) -> void:
	cyan_ghost = CYAN_GHOST.instantiate()
	cyan_ghost.setup(position, scatter_position)
	root.add_child(cyan_ghost)	
	

func create_main_menu() -> void:
	main_menu = MAIN_MENU.instantiate()
	root.add(main_menu)
	
func create_pacman(position: Vector2, direction: Vector2i) -> void:
	pacman = PACMAN.instantiate()
	pacman.setup(position, direction)
	root.add_child(pacman)

func clear_obejcts() -> void:
	cyan_ghost.queue_free()
	pink_ghost.queue_free()
	red_ghost.queue_free()
	pacman.queue_free()
