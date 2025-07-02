extends Control

# UI references for top stats
@onready var health_value = $MainContainer/TopStats/StatsContainer/HealthStat/HealthValue
@onready var attack_value = $MainContainer/TopStats/StatsContainer/AttackStat/AttackValue
@onready var defense_value = $MainContainer/TopStats/StatsContainer/DefenseStat/DefenseValue
@onready var mana_value = $MainContainer/TopStats/StatsContainer/ManaStat/ManaValue

# Character display references
@onready var player_name = $MainContainer/HeroContent/ContentContainer/EquipmentArea/CenterArea/PlayerName
@onready var player_level = $MainContainer/HeroContent/ContentContainer/EquipmentArea/CenterArea/PlayerLevel
@onready var power_value = $MainContainer/HeroContent/ContentContainer/EquipmentArea/CenterArea/PowerDisplay/PowerValue

# Equipment slot references
@onready var chest_slot = $MainContainer/HeroContent/ContentContainer/EquipmentArea/LeftEquipment/ChestSlot
@onready var armor_slot = $MainContainer/HeroContent/ContentContainer/EquipmentArea/LeftEquipment/ArmorSlot
@onready var boots_slot = $MainContainer/HeroContent/ContentContainer/EquipmentArea/LeftEquipment/BootsSlot
@onready var weapon_slot = $MainContainer/HeroContent/ContentContainer/EquipmentArea/LeftEquipment/WeaponSlot

@onready var necklace_slot = $MainContainer/HeroContent/ContentContainer/EquipmentArea/RightEquipment/NecklaceSlot
@onready var ring_slot = $MainContainer/HeroContent/ContentContainer/EquipmentArea/RightEquipment/RingSlot
@onready var backpack_slot = $MainContainer/HeroContent/ContentContainer/EquipmentArea/RightEquipment/BackpackSlot
@onready var skill_slot = $MainContainer/HeroContent/ContentContainer/EquipmentArea/RightEquipment/SkillSlot

# Bottom navigation references
@onready var combat_btn = $MainContainer/BottomNav/NavContainer/TopRow/CombatBtn
@onready var equipment_btn = $MainContainer/BottomNav/NavContainer/TopRow/EquipmentBtn
@onready var upgrades_btn = $MainContainer/BottomNav/NavContainer/TopRow/UpgradesBtn
@onready var inventory_btn = $MainContainer/BottomNav/NavContainer/TopRow/InventoryBtn
@onready var settings_btn = $MainContainer/BottomNav/NavContainer/TopRow/SettingsBtn

@onready var home_btn = $MainContainer/BottomNav/NavContainer/BottomRow/HomeBtn
@onready var hero_btn = $MainContainer/BottomNav/NavContainer/BottomRow/HeroBtn
@onready var progress_btn = $MainContainer/BottomNav/NavContainer/BottomRow/ProgressBtn
@onready var quests_btn = $MainContainer/BottomNav/NavContainer/BottomRow/QuestsBtn
@onready var shop_btn = $MainContainer/BottomNav/NavContainer/BottomRow/ShopBtn
@onready var more_btn = $MainContainer/BottomNav/NavContainer/BottomRow/MoreBtn

# Player data (will be set by Main scene)
var player_data = {}

func _ready():
	# Connect equipment slot signals (placeholders for now)
	chest_slot.pressed.connect(_on_equipment_slot_pressed.bind("Chest Armor", "🎽"))
	armor_slot.pressed.connect(_on_equipment_slot_pressed.bind("Armor", "👕"))
	boots_slot.pressed.connect(_on_equipment_slot_pressed.bind("Boots", "🥾"))
	weapon_slot.pressed.connect(_on_equipment_slot_pressed.bind("Weapon", "⚔️"))
	necklace_slot.pressed.connect(_on_equipment_slot_pressed.bind("Necklace", "📿"))
	ring_slot.pressed.connect(_on_equipment_slot_pressed.bind("Ring", "💍"))
	backpack_slot.pressed.connect(_on_equipment_slot_pressed.bind("Backpack", "🎒"))
	skill_slot.pressed.connect(_on_equipment_slot_pressed.bind("Skill Card", "🃏"))
	
	# Connect navigation buttons
	combat_btn.pressed.connect(_on_nav_pressed.bind("Combat"))
	equipment_btn.pressed.connect(_on_nav_pressed.bind("Equipment"))
	upgrades_btn.pressed.connect(_on_nav_pressed.bind("Upgrades"))
	inventory_btn.pressed.connect(_on_nav_pressed.bind("Inventory"))
	settings_btn.pressed.connect(_on_nav_pressed.bind("Settings"))
	home_btn.pressed.connect(_on_nav_pressed.bind("Home"))
	hero_btn.pressed.connect(_on_nav_pressed.bind("Hero"))
	progress_btn.pressed.connect(_on_nav_pressed.bind("Progress"))
	quests_btn.pressed.connect(_on_nav_pressed.bind("Quests"))
	shop_btn.pressed.connect(_on_nav_pressed.bind("Shop"))
	more_btn.pressed.connect(_on_nav_pressed.bind("More"))
	
	# Set Hero as active by default
	_set_active_nav_button(hero_btn)

func update_player_stats(data):
	player_data = data
	
	# Update top stats
	health_value.text = str(data.get("max_hp", 100))
	attack_value.text = str(data.get("damage", 15))
	defense_value.text = str(data.get("defense", 5))  # We'll add defense later
	mana_value.text = str(data.get("max_mp", 50))
	
	# Update character info
	player_level.text = "LEVEL " + str(data.get("level", 1))
	
	# Calculate hero power (simple sum for now)
	var hero_power = data.get("max_hp", 100) + (data.get("damage", 15) * 10) + (data.get("max_mp", 50) * 2)
	power_value.text = str(hero_power)

func _on_equipment_slot_pressed(slot_name: String, icon: String):
	# Placeholder for equipment slot interaction
	print("Equipment slot pressed: " + slot_name + " " + icon)
	# For now, just print to console - we'll add proper feedback later

func _on_nav_pressed(nav_name: String):
	if nav_name == "Combat":
		# Find the Main node and switch to combat view
		var main_node = get_tree().get_first_node_in_group("main")
		if main_node == null:
			# Try alternative method
			main_node = get_node("/root/Main/Main") 
		if main_node != null:
			main_node.switch_to_combat_view()
	elif nav_name == "Hero":
		# Already on hero view
		print("Already on Hero view")
	else:
		# Other navigation - placeholder
		print("Navigation pressed: " + nav_name)
		# For now just print - we'll add proper feedback later

func _set_active_nav_button(active_button: Button):
	# Reset all buttons to normal state
	var all_buttons = [
		combat_btn, equipment_btn, upgrades_btn, inventory_btn, settings_btn,
		home_btn, hero_btn, progress_btn, quests_btn, shop_btn, more_btn
	]
	for button in all_buttons:
		button.modulate = Color.WHITE
		button.flat = true
	
	# Highlight active button
	active_button.modulate = Color.CYAN
	active_button.flat = false