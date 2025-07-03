extends Control

# Scene references
var combat_scene = preload("res://Combat.tscn")
var hero_scene = preload("res://Hero.tscn")
var main_menu_scene = preload("res://MainMenu.tscn")

# UI References
@onready var navigation_bar = $NavigationBar
@onready var content = $Content

func _ready():
	# Load game data on next frame to ensure autoload is ready
	call_deferred("_load_game_data")
	if navigation_bar != null:
		navigation_bar.navigation_requested.connect(_on_navigation_requested)

	# Show Main Menu by default
	_show_content_scene(main_menu_scene)

func _load_game_data():
	if Global != null:
		Global.load_game()

func _on_start_button_pressed():
	_show_content_scene(combat_scene)

func _on_navigation_requested(destination: String):
	match destination:
		"Combat":
			_show_content_scene(combat_scene)
		"Hero":
			_show_content_scene(hero_scene)
		"Home":
			_show_content_scene(main_menu_scene)
		# Add more destinations as needed
		_:
			print("Navigation to ", destination, " not implemented yet.")

func _show_content_scene(scene_resource):
	# Remove all children from content
	for child in content.get_children():
		child.queue_free()
	# Instance and add the new scene
	var inst = scene_resource.instantiate()
	content.add_child(inst)
	# If the scene has a StartButton, connect it
	if inst.has_node("VBoxContainer/StartButton"):
		inst.get_node("VBoxContainer/StartButton").pressed.connect(_on_start_button_pressed)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.save_game() 
