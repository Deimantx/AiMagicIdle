extends Control

# Combat scene reference
var combat_scene = preload("res://Combat.tscn")

# UI References
@onready var start_button = $VBoxContainer/StartButton

func _ready():
	# Connect the start button
	if start_button != null:
		start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	# Switch to combat scene
	get_tree().change_scene_to_file("res://Combat.tscn") 
