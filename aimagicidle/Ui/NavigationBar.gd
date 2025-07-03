extends Panel

signal navigation_requested(destination: String)

@onready var combat_btn = $NavContainer/TopRow/CombatBtn
@onready var equipment_btn = $NavContainer/TopRow/EquipmentBtn
@onready var upgrades_btn = $NavContainer/TopRow/UpgradesBtn
@onready var inventory_btn = $NavContainer/TopRow/InventoryBtn
@onready var settings_btn = $NavContainer/TopRow/SettingsBtn
@onready var home_btn = $NavContainer/BottomRow/HomeBtn
@onready var hero_btn = $NavContainer/BottomRow/HeroBtn
@onready var progress_btn = $NavContainer/BottomRow/ProgressBtn
@onready var quests_btn = $NavContainer/BottomRow/QuestsBtn
@onready var shop_btn = $NavContainer/BottomRow/ShopBtn
@onready var more_btn = $NavContainer/BottomRow/MoreBtn

func _ready():
	combat_btn.pressed.connect(_on_btn_pressed.bind("Combat"))
	equipment_btn.pressed.connect(_on_btn_pressed.bind("Equipment"))
	upgrades_btn.pressed.connect(_on_btn_pressed.bind("Upgrades"))
	inventory_btn.pressed.connect(_on_btn_pressed.bind("Inventory"))
	settings_btn.pressed.connect(_on_btn_pressed.bind("Settings"))
	home_btn.pressed.connect(_on_btn_pressed.bind("Home"))
	hero_btn.pressed.connect(_on_btn_pressed.bind("Hero"))
	progress_btn.pressed.connect(_on_btn_pressed.bind("Progress"))
	quests_btn.pressed.connect(_on_btn_pressed.bind("Quests"))
	shop_btn.pressed.connect(_on_btn_pressed.bind("Shop"))
	more_btn.pressed.connect(_on_btn_pressed.bind("More"))

func _on_btn_pressed(destination: String):
	emit_signal("navigation_requested", destination) 


func _on_hero_btn_pressed() -> void:
	pass 
