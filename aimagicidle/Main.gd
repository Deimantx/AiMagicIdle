extends Control

# Combat scene reference
var combat_scene = preload("res://Combat.tscn")

# UI References
@onready var start_button = $VBoxContainer/StartButton

func _ready():
	# Load game data on next frame to ensure autoload is ready
	call_deferred("_load_game_data")
	
	if start_button != null:
		start_button.pressed.connect(_on_start_button_pressed)

func _load_game_data():
	if Global != null:
		Global.load_game()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Combat.tscn")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.save_game() 
