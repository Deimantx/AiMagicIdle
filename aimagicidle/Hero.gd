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
	# Connect equipment slot signals (placeholders for now) with null checks
	if chest_slot != null:
		chest_slot.pressed.connect(_on_equipment_slot_pressed.bind("Chest Armor", "🎽"))
	if armor_slot != null:
		armor_slot.pressed.connect(_on_equipment_slot_pressed.bind("Armor", "👕"))
	if boots_slot != null:
		boots_slot.pressed.connect(_on_equipment_slot_pressed.bind("Boots", "🥾"))
	if weapon_slot != null:
		weapon_slot.pressed.connect(_on_equipment_slot_pressed.bind("Weapon", "⚔️"))
	if necklace_slot != null:
		necklace_slot.pressed.connect(_on_equipment_slot_pressed.bind("Necklace", "📿"))
	if ring_slot != null:
		ring_slot.pressed.connect(_on_equipment_slot_pressed.bind("Ring", "💍"))
	if backpack_slot != null:
		backpack_slot.pressed.connect(_on_equipment_slot_pressed.bind("Backpack", "🎒"))
	if skill_slot != null:
		skill_slot.pressed.connect(_on_equipment_slot_pressed.bind("Skill Card", "🃏"))
	
	# Connect navigation buttons with null checks
	if combat_btn != null:
		combat_btn.pressed.connect(_on_nav_pressed.bind("Combat"))
	if equipment_btn != null:
		equipment_btn.pressed.connect(_on_nav_pressed.bind("Equipment"))
	if upgrades_btn != null:
		upgrades_btn.pressed.connect(_on_nav_pressed.bind("Upgrades"))
	if inventory_btn != null:
		inventory_btn.pressed.connect(_on_nav_pressed.bind("Inventory"))
	if settings_btn != null:
		settings_btn.pressed.connect(_on_nav_pressed.bind("Settings"))
	if home_btn != null:
		home_btn.pressed.connect(_on_nav_pressed.bind("Home"))
	if hero_btn != null:
		hero_btn.pressed.connect(_on_nav_pressed.bind("Hero"))
	if progress_btn != null:
		progress_btn.pressed.connect(_on_nav_pressed.bind("Progress"))
	if quests_btn != null:
		quests_btn.pressed.connect(_on_nav_pressed.bind("Quests"))
	if shop_btn != null:
		shop_btn.pressed.connect(_on_nav_pressed.bind("Shop"))
	if more_btn != null:
		more_btn.pressed.connect(_on_nav_pressed.bind("More"))
	
	# Set Hero as active by default
	if hero_btn != null:
		_set_active_nav_button(hero_btn)

func update_player_stats(data):
	player_data = data
	
	# Update top stats with null checks
	if health_value != null:
		health_value.text = str(data.get("max_hp", 100))
	if attack_value != null:
		attack_value.text = str(data.get("damage", 15))
	if defense_value != null:
		defense_value.text = str(data.get("defense", 5))  # We'll add defense later
	if mana_value != null:
		mana_value.text = str(data.get("max_mp", 50))
	
	# Update character info with null checks
	if player_level != null:
		player_level.text = "LEVEL " + str(data.get("level", 1))
	
	# Calculate hero power (simple sum for now)
	var hero_power = data.get("max_hp", 100) + (data.get("damage", 15) * 10) + (data.get("max_mp", 50) * 2)
	if power_value != null:
		power_value.text = str(hero_power)
	
	# Update stat points display if available
	var skill_points = data.get("skill_points", 0)
	if skill_points > 0:
		# Add skill points notification to the hero panel
		var notification = get_node_or_null("MainContainer/HeroContent/ContentContainer/SkillPointsNotification")
		if notification == null:
			# Create notification if it doesn't exist
			notification = Label.new()
			notification.name = "SkillPointsNotification"
			notification.text = "💎 " + str(skill_points) + " Skill Points Available!"
			notification.modulate = Color.GOLD
			notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			notification.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			
			var content_container = get_node("MainContainer/HeroContent/ContentContainer")
			if content_container != null:
				content_container.add_child(notification)
		else:
			notification.text = "💎 " + str(skill_points) + " Skill Points Available!"
	else:
		# Remove notification if no skill points
		var notification = get_node_or_null("MainContainer/HeroContent/ContentContainer/SkillPointsNotification")
		if notification != null:
			notification.queue_free()

func _on_equipment_slot_pressed(slot_name: String, icon: String):
	# Placeholder for equipment slot interaction
	print("Equipment slot pressed: " + slot_name + " " + icon)
	# For now, just print to console - we'll add proper feedback later

func _on_nav_pressed(nav_name: String):
	if nav_name == "Combat":
		# Switch to combat view by calling parent (Combat scene)
		var parent = get_parent()
		if parent != null and parent.has_method("switch_to_combat_view"):
			parent.switch_to_combat_view()
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
		if button != null:
			button.modulate = Color.WHITE
			button.flat = true
	
	# Highlight active button
	if active_button != null:
		active_button.modulate = Color.CYAN
		active_button.flat = false
