extends Control

# Player stats
var player_level = 1
var player_xp = 0
var player_xp_needed = 100
var player_hp = 100.0
var player_max_hp = 100.0
var player_mp = 50.0
var player_max_mp = 50.0
var player_gold = 0
var player_damage = 15
var player_skill_points = 0

# Player stats (STR, AGI, INT, VIT, SPR)
var player_str = 5
var player_agi = 5
var player_int = 5
var player_vit = 5
var player_spr = 5

# Additional player stats
var player_crit_rate = 0.0
var player_crit_damage = 1.5
var player_dodge_chance = 0.0
var player_hit_chance = 100.0

# Combat timers
var player_attack_timer = 0.0
var player_attack_cooldown = 2.5
var player_skill_timer = 0.0
var player_skill_cooldown = 3.5

# Enemy variables
var enemy_name = "Forest Wolf"
var enemy_level = 1
var enemy_hp = 80.0
var enemy_max_hp = 80.0
var enemy_damage = 12
var enemy_ability = "Vicious Bite"
var enemy_ability_desc = "Deals 1.3x damage"
var enemy_description = "A fierce wolf that hunts in packs"
var enemy_alive = true

# Enemy combat timers
var enemy_attack_timer = 0.0
var enemy_attack_cooldown = 2.0
var enemy_skill_timer = 0.0
var enemy_skill_cooldown = 2.5

# Respawn system
var is_respawning = false
var respawn_timer = 0.0
var respawn_delay = 3.0

# Location and monsters
var current_location = "Forest"

# Monster definitions
var monsters = {
	"Forest": [
		{"name": "Forest Wolf", "level": 1, "max_hp": 80, "damage": 12, "ability": "Vicious Bite", "ability_desc": "Deals 1.3x damage", "description": "A fierce wolf that hunts in packs"},
		{"name": "Giant Spider", "level": 2, "max_hp": 120, "damage": 15, "ability": "Poison Web", "ability_desc": "Deals damage over time", "description": "A massive spider with deadly venom"},
		{"name": "Bandit Archer", "level": 3, "max_hp": 100, "damage": 18, "ability": "Precise Shot", "ability_desc": "High chance to crit", "description": "A skilled archer with deadly accuracy"}
	],
	"Mine": [
		{"name": "Cave Bat", "level": 2, "max_hp": 90, "damage": 14, "ability": "Sonic Scream", "ability_desc": "Stuns and damages", "description": "A bat that uses sound to attack"},
		{"name": "Rock Golem", "level": 4, "max_hp": 200, "damage": 20, "ability": "Stone Throw", "ability_desc": "Deals 1.5x damage", "description": "A massive creature made of stone"},
		{"name": "Miner Zombie", "level": 3, "max_hp": 150, "damage": 16, "ability": "Infection", "ability_desc": "Reduces player damage", "description": "A zombie that spreads disease"}
	],
	"Outskirts": [
		{"name": "Desert Scorpion", "level": 3, "max_hp": 110, "damage": 17, "ability": "Venom Sting", "ability_desc": "Poison damage over time", "description": "A deadly scorpion with potent venom"},
		{"name": "Nomad Warrior", "level": 4, "max_hp": 130, "damage": 19, "ability": "Dual Strike", "ability_desc": "Attacks twice", "description": "A skilled warrior from the desert"},
		{"name": "Sand Elemental", "level": 5, "max_hp": 180, "damage": 22, "ability": "Sandstorm", "ability_desc": "Deals damage to all", "description": "A powerful elemental of sand"}
	]
}

# UI References
@onready var level_label = $VBoxContainer/PlayerStats/Level
@onready var xp_bar = $VBoxContainer/PlayerStats/XPBar
@onready var xp_bar_label = $VBoxContainer/PlayerStats/XPBar/XPLabel
@onready var hp_bar = $VBoxContainer/PlayerStats/HPBar
@onready var hp_label = $VBoxContainer/PlayerStats/HPBar/HPLabel
@onready var mp_bar = $VBoxContainer/PlayerStats/MPBar
@onready var mp_label = $VBoxContainer/PlayerStats/MPBar/MPLabel
@onready var gold_label = $VBoxContainer/PlayerStats/Gold

# Player action UI
@onready var player_attack_timer_label = $VBoxContainer/PlayerStats/PlayerActions/AttackTimer
@onready var player_attack_bar = $VBoxContainer/PlayerStats/PlayerActions/AttackBar
@onready var player_skill_timer_label = $VBoxContainer/PlayerStats/PlayerActions/SkillTimer
@onready var player_skill_bar = $VBoxContainer/PlayerStats/PlayerActions/SkillBar
@onready var player_skill_desc_label = $VBoxContainer/PlayerStats/PlayerActions/SkillDesc

# Enemy UI
@onready var enemy_name_label = $VBoxContainer/EnemyInfo/EnemyName
@onready var enemy_hp_bar = $VBoxContainer/EnemyInfo/EnemyHPBar
@onready var enemy_hp_label = $VBoxContainer/EnemyInfo/EnemyHPBar/EnemyHPLabel
@onready var enemy_attack_timer_label = $VBoxContainer/EnemyInfo/EnemyActions/EnemyAttackTimer
@onready var enemy_attack_bar = $VBoxContainer/EnemyInfo/EnemyActions/EnemyAttackBar
@onready var enemy_skill_timer_label = $VBoxContainer/EnemyInfo/EnemyActions/EnemySkillTimer
@onready var enemy_skill_bar = $VBoxContainer/EnemyInfo/EnemyActions/EnemySkillBar
@onready var enemy_skill_desc_label = $VBoxContainer/EnemyInfo/EnemyActions/EnemySkillDesc
@onready var respawn_timer_label = $VBoxContainer/EnemyInfo/RespawnTimer

# Location and monster selector dropdowns
@onready var location_dropdown = $VBoxContainer/EnemyInfo/LocationSelector/LocationDropdown
@onready var monster_dropdown = $VBoxContainer/EnemyInfo/LocationSelector/MonsterDropdown

@onready var combat_log = $VBoxContainer/CombatLog/ScrollContainer/LogText
@onready var reward_text = $VBoxContainer/LootDisplay/RewardText

# Hero scene reference
var hero_scene = preload("res://Hero.tscn")
var hero_instance = null
var current_view = "combat"

# Bottom navigation buttons
@onready var combat_btn = $VBoxContainer/BottomNav/NavContainer/TopRow/CombatBtn
@onready var hero_btn = $VBoxContainer/BottomNav/NavContainer/BottomRow/HeroBtn
@onready var inventory_btn = $VBoxContainer/BottomNav/NavContainer/TopRow/InventoryBtn
@onready var equipment_btn = $VBoxContainer/BottomNav/NavContainer/TopRow/EquipmentBtn
@onready var upgrades_btn = $VBoxContainer/BottomNav/NavContainer/TopRow/UpgradesBtn
@onready var settings_btn = $VBoxContainer/BottomNav/NavContainer/TopRow/SettingsBtn
@onready var home_btn = $VBoxContainer/BottomNav/NavContainer/BottomRow/HomeBtn
@onready var progress_btn = $VBoxContainer/BottomNav/NavContainer/BottomRow/ProgressBtn
@onready var quests_btn = $VBoxContainer/BottomNav/NavContainer/BottomRow/QuestsBtn
@onready var shop_btn = $VBoxContainer/BottomNav/NavContainer/BottomRow/ShopBtn
@onready var more_btn = $VBoxContainer/BottomNav/NavContainer/BottomRow/MoreBtn

func _ready():
	# Load player data from Global script
	player_level = Global.get_game_data("player_level", 1)
	player_xp = Global.get_game_data("player_xp", 0)
	player_xp_needed = Global.get_game_data("player_xp_needed", 100)
	player_hp = Global.get_game_data("player_hp", 100)
	player_max_hp = Global.get_game_data("player_max_hp", 100)
	player_mp = Global.get_game_data("player_mp", 50)
	player_max_mp = Global.get_game_data("player_max_mp", 50)
	player_gold = Global.get_game_data("player_gold", 0)
	player_skill_points = Global.get_game_data("player_skill_points", 0)
	player_str = Global.get_game_data("player_str", 5)
	player_agi = Global.get_game_data("player_agi", 5)
	player_int = Global.get_game_data("player_int", 5)
	player_vit = Global.get_game_data("player_vit", 5)
	player_spr = Global.get_game_data("player_spr", 5)
	current_location = Global.get_game_data("current_location", "Forest")
	# Setup dropdowns
	if location_dropdown != null:
		location_dropdown.item_selected.connect(_on_location_selected)
		_setup_location_dropdown()
	if monster_dropdown != null:
		monster_dropdown.item_selected.connect(_on_monster_selected)
		_setup_monster_dropdown()
	if monster_dropdown != null:
		monster_dropdown.selected = Global.get_game_data("monster_selected", 0)
	# Calculate initial player stats
	calculate_player_stats()
	
	# Connect bottom navigation buttons
	if combat_btn != null:
		combat_btn.pressed.connect(_on_combat_pressed)
	if hero_btn != null:
		hero_btn.pressed.connect(_on_hero_pressed)
	if inventory_btn != null:
		inventory_btn.pressed.connect(_on_inventory_pressed)
	if equipment_btn != null:
		equipment_btn.pressed.connect(_on_equipment_pressed)
	if upgrades_btn != null:
		upgrades_btn.pressed.connect(_on_upgrades_pressed)
	if settings_btn != null:
		settings_btn.pressed.connect(_on_settings_pressed)
	if home_btn != null:
		home_btn.pressed.connect(_on_home_pressed)
	if progress_btn != null:
		progress_btn.pressed.connect(_on_progress_pressed)
	if quests_btn != null:
		quests_btn.pressed.connect(_on_quests_pressed)
	if shop_btn != null:
		shop_btn.pressed.connect(_on_shop_pressed)
	if more_btn != null:
		more_btn.pressed.connect(_on_more_pressed)
	
	# Set combat as active button
	_set_active_nav_button(combat_btn)

func calculate_player_stats():
	# Base stats
	var base_hp = 100
	var base_mp = 50
	var base_damage = 15
	
	# Calculate stats from STR/AGI/INT/VIT/SPR
	player_max_hp = base_hp + (player_vit * 10) + int(base_hp * (player_vit * 0.01))
	player_max_mp = base_mp + (player_int * 5) + (player_spr * 10) + int(base_mp * (player_int * 0.01))
	player_damage = base_damage + (player_str * 2)
	player_crit_rate = player_agi * 0.1
	player_crit_damage = 1.5 + (player_str * 0.01)
	player_dodge_chance = player_agi * 0.05
	player_hit_chance = 100.0 + (player_agi * 0.1)
	
	# Ensure HP/MP don't go below current values
	if player_hp > player_max_hp:
		player_hp = player_max_hp
	if player_mp > player_max_mp:
		player_mp = player_max_mp
	
func _process(delta):
	if is_respawning:
		handle_respawn(delta)
	elif enemy_alive:
		handle_combat(delta)
	
	# Update UI every frame to show progress bars
	update_ui()

func handle_combat(delta):
	# Player attack timer
	player_attack_timer += delta
	if player_attack_timer >= player_attack_cooldown:
		player_basic_attack()
		player_attack_timer = 0.0
	
	# Player skill timer (Fireball)
	player_skill_timer += delta
	if player_skill_timer >= player_skill_cooldown and player_mp >= 10:
		player_cast_fireball()
		player_skill_timer = 0.0
	
	# MP regeneration (1 MP per second)
	if player_mp < player_max_mp:
		player_mp = min(player_max_mp, player_mp + delta)
	
	# Enemy attack timer
	enemy_attack_timer += delta
	if enemy_attack_timer >= enemy_attack_cooldown:
		enemy_basic_attack()
		enemy_attack_timer = 0.0
	
	# Enemy skill timer (Vicious Bite)
	enemy_skill_timer += delta
	if enemy_skill_timer >= enemy_skill_cooldown:
		enemy_vicious_bite()
		enemy_skill_timer = 0.0

func player_basic_attack():
	if not enemy_alive:
		return
		
	var damage = player_damage + randi() % 6 - 2  # ±2 damage variance
	enemy_hp -= damage
	add_to_combat_log("[color=lime]💥 Player attacks for [color=yellow]" + str(damage) + "[/color] damage![/color]")
	
	if enemy_hp <= 0:
		enemy_died()
	else:
		update_ui()

func player_cast_fireball():
	if not enemy_alive or player_mp < 10:
		return
		
	player_mp -= 10
	var damage = (player_damage * 1.5) + randi() % 8 - 3  # 1.5x damage with variance
	enemy_hp -= damage
	add_to_combat_log("[color=orange]🔥 Player casts Fireball for [color=yellow]" + str(damage) + "[/color] damage![/color]")
	
	if enemy_hp <= 0:
		enemy_died()
	else:
		update_ui()

func enemy_basic_attack():
	if not enemy_alive:
		return
		
	var damage = enemy_damage + randi() % 4 - 1  # ±1 damage variance
	player_hp -= damage
	add_to_combat_log("[color=lightcoral]⚔️ " + enemy_name + " attacks! You take [color=red]" + str(damage) + "[/color] damage![/color]")
	
	if player_hp <= 0:
		player_hp = 1  # Player can't die in idle game
	
	update_ui()

func enemy_vicious_bite():
	if not enemy_alive:
		return
		
	var damage = (enemy_damage * 1.3) + randi() % 5 - 2  # 1.3x damage with variance
	player_hp -= damage
	add_to_combat_log("[color=crimson]🩸 " + enemy_name + " uses Vicious Bite! You take [color=red]" + str(damage) + "[/color] damage![/color]")
	
	if player_hp <= 0:
		player_hp = 1  # Player can't die in idle game
		
	update_ui()

func enemy_died():
	enemy_alive = false
	enemy_hp = 0
	
	# Calculate rewards
	var xp_reward = 10 + (enemy_level * 2)
	var gold_reward = 10 + (enemy_level * 3)
	
	player_xp += xp_reward
	player_gold += gold_reward
	
	add_to_combat_log("[color=green]💀 " + enemy_name + " is defeated![/color]")
	add_to_combat_log("[color=yellow]💰 Gained " + str(xp_reward) + " XP and " + str(gold_reward) + " Gold![/color]")
	add_to_combat_log("[color=cyan]🔄 New enemy will spawn in " + str(int(respawn_delay)) + " seconds...[/color]")
	show_rewards(xp_reward, gold_reward)
	
	# Check for level up
	check_level_up()
	
	# Start respawn
	start_respawn()
	
	update_ui()

func show_rewards(xp_gain, gold_gain):
	if reward_text != null:
		reward_text.text = "+" + str(xp_gain) + " XP, +" + str(gold_gain) + " Gold"
		reward_text.modulate = Color.GREEN
	
	# Create a timer to clear the reward text after 3 seconds
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.timeout.connect(clear_reward_text)
	timer.start()

func clear_reward_text():
	if reward_text != null:
		reward_text.text = ""
		reward_text.modulate = Color.GREEN

func check_level_up():
	while player_xp >= player_xp_needed:
		player_xp -= player_xp_needed
		player_level += 1
		player_skill_points += 1
		player_xp_needed = player_level * 100
		add_to_combat_log("[color=gold]⭐ LEVEL UP! Now level " + str(player_level) + "! You gained 1 Skill Point![/color]")
		add_to_combat_log("[color=cyan]💡 Use the Hero panel to spend your skill points![/color]")
		# Save to Global script
		Global.set_game_data("player_level", player_level)
		Global.set_game_data("player_xp", player_xp)
		Global.set_game_data("player_xp_needed", player_xp_needed)
		Global.set_game_data("player_skill_points", player_skill_points)

func start_respawn():
	is_respawning = true
	respawn_timer = respawn_delay
	
	# Reset combat timers
	player_attack_timer = 0.0
	player_skill_timer = 0.0
	enemy_attack_timer = 0.0
	enemy_skill_timer = 0.0

func handle_respawn(delta):
	respawn_timer -= delta
	
	if respawn_timer <= 0:
		# Spawn the currently selected monster from dropdown
		if monster_dropdown != null and monster_dropdown.selected >= 0:
			var selected_monster_name = monster_dropdown.get_item_text(monster_dropdown.selected)
			spawn_specific_monster(selected_monster_name)
		else:
			# Fallback to random monster if no selection
			spawn_random_monster()
		
		is_respawning = false
		
		update_ui()
	else:
		# Update respawn timer display
		if respawn_timer_label != null:
			respawn_timer_label.text = "Respawn in " + str(int(ceil(respawn_timer))) + "s"

func spawn_random_monster():
	var location_monsters = monsters[current_location]
	var random_monster = location_monsters[randi() % location_monsters.size()]
	
	enemy_name = random_monster.name
	enemy_level = random_monster.level
	enemy_max_hp = random_monster.max_hp
	enemy_hp = enemy_max_hp
	enemy_damage = random_monster.damage
	enemy_ability = random_monster.ability
	enemy_ability_desc = random_monster.ability_desc
	enemy_description = random_monster.description
	enemy_alive = true

func spawn_specific_monster(monster_name: String):
	# Find the monster in the current location's monster list
	var location_monsters = monsters[current_location]
	for monster in location_monsters:
		if monster.name == monster_name:
			enemy_name = monster.name
			enemy_level = monster.level
			enemy_max_hp = monster.max_hp
			enemy_hp = enemy_max_hp
			enemy_damage = monster.damage
			enemy_ability = monster.ability
			enemy_ability_desc = monster.ability_desc
			enemy_description = monster.description
			enemy_alive = true
			
			# Reset player stats (HP/MP) when switching monsters
			player_hp = player_max_hp
			player_mp = player_max_mp
			
			# Reset combat timers
			player_attack_timer = 0.0
			player_skill_timer = 0.0
			enemy_attack_timer = 0.0
			enemy_skill_timer = 0.0
			
			add_to_combat_log("[color=purple]👹 " + monster_name + " has appeared![/color]")
			update_ui()
			return
	
	# If monster not found, spawn random monster instead
	add_to_combat_log("[color=red]❌ Monster not found, spawning random monster instead[/color]")
	spawn_random_monster()

func update_ui():
	# Player stats with null checks
	if level_label != null:
		level_label.text = "Level: " + str(int(player_level))
	if gold_label != null:
		gold_label.text = "Gold: " + str(int(player_gold))
	
	# XP progress bar with null checks
	if xp_bar != null:
		xp_bar.max_value = int(player_xp_needed)
		xp_bar.value = int(player_xp)
	if xp_bar_label != null:
		xp_bar_label.text = "XP: " + str(int(player_xp)) + " / " + str(int(player_xp_needed))
	
	# HP bar with null checks
	if hp_bar != null:
		hp_bar.max_value = int(player_max_hp)
		hp_bar.value = int(player_hp)
	if hp_label != null:
		hp_label.text = "HP: " + str(int(player_hp)) + " / " + str(int(player_max_hp))
	
	# MP bar with null checks
	if mp_bar != null:
		mp_bar.max_value = int(player_max_mp)
		mp_bar.value = int(player_mp)
	if mp_label != null:
		mp_label.text = "MP: " + str(int(player_mp)) + " / " + str(int(player_max_mp))
	
	# Player action progress bars with null checks
	if player_attack_bar != null:
		player_attack_bar.max_value = player_attack_cooldown
		player_attack_bar.value = player_attack_timer
	
	# Player attack timer display
	if player_attack_timer_label != null:
		if player_attack_timer >= player_attack_cooldown:
			player_attack_timer_label.text = "Ready!"
		else:
			var remaining = player_attack_cooldown - player_attack_timer
			player_attack_timer_label.text = str(int(ceil(remaining))) + "s"
	
	if player_skill_bar != null:
		player_skill_bar.max_value = player_skill_cooldown
		player_skill_bar.value = player_skill_timer
	
	# Player skill timer display
	if player_skill_timer_label != null:
		if player_skill_timer >= player_skill_cooldown and player_mp >= 10:
			player_skill_timer_label.text = "Ready!"
		elif player_mp < 10:
			player_skill_timer_label.text = "No MP"
		else:
			var remaining = player_skill_cooldown - player_skill_timer
			player_skill_timer_label.text = str(int(ceil(remaining))) + "s"
	
	# Update skill descriptions
	if player_skill_desc_label != null:
		player_skill_desc_label.text = "Fireball: Deals 1.5x your damage to the enemy. Costs 10 MP."
	if enemy_skill_desc_label != null:
		enemy_skill_desc_label.text = enemy_ability + ": " + enemy_ability_desc
	
	# Enemy info with null checks
	if enemy_alive:
		if enemy_name_label != null:
			enemy_name_label.text = enemy_name + " Lv." + str(int(enemy_level))
		if enemy_hp_bar != null:
			enemy_hp_bar.max_value = int(enemy_max_hp)
			enemy_hp_bar.value = int(enemy_hp)
		if enemy_hp_label != null:
			enemy_hp_label.text = "HP: " + str(int(enemy_hp)) + " / " + str(int(enemy_max_hp))
		if respawn_timer_label != null:
			respawn_timer_label.text = ""
		
		# Enemy action progress bars with null checks
		if enemy_attack_bar != null:
			enemy_attack_bar.max_value = enemy_attack_cooldown
			enemy_attack_bar.value = enemy_attack_timer
		
		# Enemy attack timer display
		if enemy_attack_timer_label != null:
			if enemy_attack_timer >= enemy_attack_cooldown:
				enemy_attack_timer_label.text = "Ready!"
			else:
				var remaining = enemy_attack_cooldown - enemy_attack_timer
				enemy_attack_timer_label.text = str(int(ceil(remaining))) + "s"
		
		if enemy_skill_bar != null:
			enemy_skill_bar.max_value = enemy_skill_cooldown
			enemy_skill_bar.value = enemy_skill_timer
		
		# Enemy skill timer display
		if enemy_skill_timer_label != null:
			if enemy_skill_timer >= enemy_skill_cooldown:
				enemy_skill_timer_label.text = "Ready!"
			else:
				var remaining = enemy_skill_cooldown - enemy_skill_timer
				enemy_skill_timer_label.text = str(int(ceil(remaining))) + "s"
		
		# Update enemy skill label to show ability
		var skill_label = get_node("VBoxContainer/EnemyInfo/EnemyActions/EnemySkillLabel")
		if skill_label != null:
			skill_label.text = enemy_ability + ":"
	else:
		if enemy_name_label != null:
			enemy_name_label.text = enemy_name + " (Dead)"
		if enemy_hp_bar != null:
			enemy_hp_bar.value = 0
		if enemy_hp_label != null:
			enemy_hp_label.text = "HP: 0 / " + str(int(enemy_max_hp))
		
		# Reset enemy action bars when dead with null checks
		if enemy_attack_bar != null:
			enemy_attack_bar.value = 0
		if enemy_skill_bar != null:
			enemy_skill_bar.value = 0
		
		# Enemy timers when dead
		if enemy_attack_timer_label != null:
			enemy_attack_timer_label.text = "Dead"
		if enemy_skill_timer_label != null:
			enemy_skill_timer_label.text = "Dead"

func add_to_combat_log(message):
	if combat_log != null:
		combat_log.append_text(message + "\n")
		
		# Limit log lines to prevent memory issues
		var lines = combat_log.get_parsed_text().split("\n")
		if lines.size() > 50:
			var limited_text = ""
			for i in range(lines.size() - 40, lines.size()):
				if i < lines.size():
					limited_text += lines[i] + "\n"
			combat_log.text = limited_text

# Bottom Navigation Functions
func _set_active_nav_button(active_button: Button):
	# Reset all buttons to normal state
	var buttons = [combat_btn, hero_btn, inventory_btn, equipment_btn, upgrades_btn, settings_btn, home_btn, progress_btn, quests_btn, shop_btn, more_btn]
	for button in buttons:
		if button != null:
			button.modulate = Color.WHITE
			button.flat = true
	
	# Highlight active button
	if active_button != null:
		active_button.modulate = Color.CYAN
		active_button.flat = false

func _on_combat_pressed():
	_set_active_nav_button(combat_btn)

func _on_hero_pressed():
	switch_to_hero_view()

func _on_inventory_pressed():
	_set_active_nav_button(inventory_btn)

func _on_equipment_pressed():
	_set_active_nav_button(equipment_btn)

func _on_upgrades_pressed():
	_set_active_nav_button(upgrades_btn)

func _on_settings_pressed():
	_set_active_nav_button(settings_btn)

func _on_home_pressed():
	_set_active_nav_button(home_btn)

func _on_progress_pressed():
	_set_active_nav_button(progress_btn)

func _on_quests_pressed():
	_set_active_nav_button(quests_btn)

func _on_shop_pressed():
	_set_active_nav_button(shop_btn)

func _on_more_pressed():
	_set_active_nav_button(more_btn)

# Dropdown setup functions
func _setup_location_dropdown():
	if location_dropdown == null:
		return
	
	location_dropdown.clear()
	location_dropdown.add_item("🌲 Forest")
	location_dropdown.add_item("⛏️ Mine")
	location_dropdown.add_item("🏘️ Outskirts")
	
	# Set current location as selected
	match current_location:
		"Forest":
			location_dropdown.selected = 0
		"Mine":
			location_dropdown.selected = 1
		"Outskirts":
			location_dropdown.selected = 2

func _setup_monster_dropdown():
	if monster_dropdown == null:
		return
	
	monster_dropdown.clear()
	
	# Add monsters based on current location
	match current_location:
		"Forest":
			monster_dropdown.add_item("Forest Wolf")
			monster_dropdown.add_item("Giant Spider")
			monster_dropdown.add_item("Bandit Archer")
		"Mine":
			monster_dropdown.add_item("Cave Bat")
			monster_dropdown.add_item("Rock Golem")
			monster_dropdown.add_item("Miner Zombie")
		"Outskirts":
			monster_dropdown.add_item("Desert Scorpion")
			monster_dropdown.add_item("Nomad Warrior")
			monster_dropdown.add_item("Sand Elemental")
	
	# Set first monster as selected
	monster_dropdown.selected = 0

# Dropdown selection functions
func _on_location_selected(index):
	var locations = ["Forest", "Mine", "Outskirts"]
	current_location = locations[index]
	_setup_monster_dropdown()
	add_to_combat_log("[color=green]📍 Switched to " + current_location + " location[/color]")
	if enemy_alive:
		add_to_combat_log("[color=yellow]⚠️ Current enemy will remain until defeated[/color]")
	# Save to Global script
	Global.set_game_data("current_location", current_location)

func _on_monster_selected(index):
	var monster_name = monster_dropdown.get_item_text(index)
	spawn_specific_monster(monster_name)
	add_to_combat_log("[color=blue]🎯 Switched to " + monster_name + "![/color]")
	# Save to Global script
	Global.set_game_data("monster_selected", monster_dropdown.selected)

# View switching functions
func switch_to_hero_view():
	if current_view == "hero":
		return
	current_view = "hero"
	get_node("VBoxContainer/PlayerStats").visible = false
	get_node("VBoxContainer/EnemyInfo").visible = false
	get_node("VBoxContainer/CombatLog").visible = false
	get_node("VBoxContainer/LootDisplay").visible = false
	if hero_instance == null:
		hero_instance = hero_scene.instantiate()
		add_child(hero_instance)
	hero_instance.visible = true
	var player_data = {
		"level": player_level,
		"max_hp": player_max_hp,
		"damage": player_damage,
		"defense": 5,
		"max_mp": player_max_mp,
		"skill_points": player_skill_points
	}
	hero_instance.update_player_stats(player_data)

func switch_to_combat_view():
	if current_view == "combat":
		return
	current_view = "combat"
	if hero_instance != null:
		hero_instance.visible = false
	get_node("VBoxContainer/PlayerStats").visible = true
	get_node("VBoxContainer/EnemyInfo").visible = true
	get_node("VBoxContainer/CombatLog").visible = true
	get_node("VBoxContainer/LootDisplay").visible = true
	_set_active_nav_button(combat_btn) 
