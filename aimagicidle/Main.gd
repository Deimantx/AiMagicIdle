extends Control

# Scene management
@onready var hero_scene = preload("res://Hero.tscn")
var hero_instance = null
var current_view = "combat"  # "combat" or "hero"

# Player stats
var player_level = 1
var player_xp = 0
var player_xp_needed = 100
var player_max_hp = 100
var player_hp = 100
var player_max_mp = 50
var player_mp = 50
var player_damage = 15
var player_gold = 0

# Enemy stats
var enemy_name = "Wolf"
var enemy_level = 1
var enemy_max_hp = 80
var enemy_hp = 80
var enemy_damage = 12
var enemy_alive = true

# Combat timers
var player_attack_cooldown = 2.5
var player_skill_cooldown = 3.5
var enemy_attack_cooldown = 2.0
var enemy_skill_cooldown = 2.5

var player_attack_timer = 0.0
var player_skill_timer = 0.0
var enemy_attack_timer = 0.0
var enemy_skill_timer = 0.0

# Respawn system
var respawn_delay = 5.0
var respawn_timer = 0.0
var is_respawning = false

# UI references
@onready var level_label = $VBoxContainer/PlayerStats/Level
@onready var xp_bar = $VBoxContainer/PlayerStats/XPBar
@onready var xp_bar_label = $VBoxContainer/PlayerStats/XPBar/XPLabel
@onready var hp_bar = $VBoxContainer/PlayerStats/HPBar
@onready var hp_label = $VBoxContainer/PlayerStats/HPBar/HPLabel
@onready var mp_bar = $VBoxContainer/PlayerStats/MPBar
@onready var mp_label = $VBoxContainer/PlayerStats/MPBar/MPLabel
@onready var gold_label = $VBoxContainer/PlayerStats/Gold

@onready var player_attack_bar = $VBoxContainer/PlayerStats/PlayerActions/AttackBar
@onready var player_attack_timer_label = $VBoxContainer/PlayerStats/PlayerActions/AttackTimer
@onready var player_skill_bar = $VBoxContainer/PlayerStats/PlayerActions/SkillBar
@onready var player_skill_timer_label = $VBoxContainer/PlayerStats/PlayerActions/SkillTimer

@onready var enemy_name_label = $VBoxContainer/EnemyInfo/EnemyName
@onready var enemy_hp_bar = $VBoxContainer/EnemyInfo/EnemyHPBar
@onready var enemy_hp_label = $VBoxContainer/EnemyInfo/EnemyHPBar/EnemyHPLabel
@onready var enemy_attack_bar = $VBoxContainer/EnemyInfo/EnemyActions/EnemyAttackBar
@onready var enemy_attack_timer_label = $VBoxContainer/EnemyInfo/EnemyActions/EnemyAttackTimer
@onready var enemy_skill_bar = $VBoxContainer/EnemyInfo/EnemyActions/EnemySkillBar
@onready var enemy_skill_timer_label = $VBoxContainer/EnemyInfo/EnemyActions/EnemySkillTimer
@onready var respawn_timer_label = $VBoxContainer/EnemyInfo/RespawnTimer

@onready var combat_log = $VBoxContainer/CombatLog/ScrollContainer/LogText
@onready var reward_text = $VBoxContainer/LootDisplay/RewardText

# Bottom navigation buttons (these don't exist in the current scene)
@onready var combat_btn = null
@onready var hero_btn = null
@onready var inventory_btn = null
@onready var skills_btn = null
@onready var shop_btn = null

func _ready():
	# Add to group so Hero panel can find this node
	add_to_group("main")
	
	update_ui()
	add_to_combat_log("[color=yellow]⚔️ Combat begins! Prepare for battle![/color]")
	
	# Note: Bottom navigation buttons don't exist in the current scene structure
	# Combat will start automatically
	
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
		
		# Increase stats on level up
		player_max_hp += 10
		player_hp = player_max_hp  # Full heal on level up
		player_max_mp += 3
		player_mp = player_max_mp  # Full MP restore on level up
		player_damage += 2
		
		# Increase XP needed for next level
		player_xp_needed = player_level * 100
		
		add_to_combat_log("[color=gold]⭐ LEVEL UP! Now level " + str(player_level) + "! (+10 HP, +3 MP, +2 Damage)[/color]")

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
		# Respawn enemy
		enemy_alive = true
		enemy_hp = enemy_max_hp
		is_respawning = false
		
		# Restore player HP/MP
		player_hp = player_max_hp
		player_mp = player_max_mp
		
		add_to_combat_log("[color=cyan]🐺 A new " + enemy_name + " appears! Player restored to full health![/color]")
		update_ui()
	else:
		# Update respawn timer display
		if respawn_timer_label != null:
			respawn_timer_label.text = "🔄 New enemy spawning in: " + str(int(ceil(respawn_timer))) + "s"

func update_ui():
	# Player stats with null checks
	if level_label != null:
		level_label.text = "Level: " + str(player_level)
	if gold_label != null:
		gold_label.text = "Gold: " + str(player_gold)
	
	# XP progress bar with null checks
	if xp_bar != null:
		xp_bar.max_value = player_xp_needed
		xp_bar.value = player_xp
	if xp_bar_label != null:
		xp_bar_label.text = "XP: " + str(player_xp) + " / " + str(player_xp_needed)
	
	# HP bar with null checks
	if hp_bar != null:
		hp_bar.max_value = player_max_hp
		hp_bar.value = player_hp
	if hp_label != null:
		hp_label.text = "HP: " + str(int(player_hp)) + " / " + str(player_max_hp)
	
	# MP bar with null checks
	if mp_bar != null:
		mp_bar.max_value = player_max_mp
		mp_bar.value = player_mp
	if mp_label != null:
		mp_label.text = "MP: " + str(int(player_mp)) + " / " + str(player_max_mp)
	
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
	
			# Enemy info with null checks
	if enemy_alive:
		if enemy_name_label != null:
			enemy_name_label.text = enemy_name + " Lv." + str(enemy_level)
		if enemy_hp_bar != null:
			enemy_hp_bar.max_value = enemy_max_hp
			enemy_hp_bar.value = enemy_hp
		if enemy_hp_label != null:
			enemy_hp_label.text = "HP: " + str(int(enemy_hp)) + " / " + str(enemy_max_hp)
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
	else:
		if enemy_name_label != null:
			enemy_name_label.text = enemy_name + " (Dead)"
		if enemy_hp_bar != null:
			enemy_hp_bar.value = 0
		if enemy_hp_label != null:
			enemy_hp_label.text = "HP: 0 / " + str(enemy_max_hp)
		
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

# Bottom Navigation Functions (commented out - navigation doesn't exist in current scene)
# func _set_active_nav_button(active_button: Button):
# 	# Reset all buttons to normal state
# 	var buttons = [combat_btn, hero_btn, inventory_btn, skills_btn, shop_btn]
# 	for button in buttons:
# 		if button != null:
# 			button.modulate = Color.WHITE
# 			button.flat = true
# 	
# 	# Highlight active button
# 	if active_button != null:
# 		active_button.modulate = Color.CYAN
# 		active_button.flat = false

# func _on_combat_pressed():
# 	_set_active_nav_button(combat_btn)
# 	add_to_combat_log("[color=cyan]📊 Combat view is already active![/color]")

# func _on_hero_pressed():
# 	switch_to_hero_view()

# func _on_inventory_pressed():
# 	_set_active_nav_button(inventory_btn)
# 	add_to_combat_log("[color=cyan]🎒 Inventory - Coming Soon! (Items, weapons, armor, consumables)[/color]")

# func _on_skills_pressed():
# 	_set_active_nav_button(skills_btn)
# 	add_to_combat_log("[color=cyan]⭐ Skills - Coming Soon! (Skill tree, upgrades, talents)[/color]")

# func _on_shop_pressed():
# 	_set_active_nav_button(shop_btn)
# 	add_to_combat_log("[color=cyan]🏪 Shop - Coming Soon! (Buy weapons, armor, items with gold)[/color]")

# View switching functions (commented out - navigation doesn't exist in current scene)
# func switch_to_hero_view():
# 	if current_view == "hero":
# 		return
# 		
# 	current_view = "hero"
# 	
# 	# Hide combat UI
# 	get_node("MainContainer/GameContent").visible = false
# 	get_node("MainContainer/BottomNav").visible = false
# 	
# 	# Create and show hero panel if it doesn't exist
# 	if hero_instance == null:
# 		hero_instance = hero_scene.instantiate()
# 		add_child(hero_instance)
# 	
# 	hero_instance.visible = true
# 	
# 	# Update hero panel with current player stats
# 	var player_data = {
# 		"level": player_level,
# 		"max_hp": player_max_hp,
# 		"damage": player_damage,
# 		"defense": 5,  # We'll add this stat later
# 		"max_mp": player_max_mp
# 	}
# 	hero_instance.update_player_stats(player_data)
# 	
# 	add_to_combat_log("[color=cyan]👤 Switched to Hero Panel[/color]")

# func switch_to_combat_view():
# 	if current_view == "combat":
# 		return
# 		
# 	current_view = "combat"
# 	
# 	# Hide hero panel
# 	if hero_instance != null:
# 		hero_instance.visible = false
# 	
# 	# Show combat UI
# 	get_node("MainContainer/GameContent").visible = true
# 	get_node("MainContainer/BottomNav").visible = true
# 	
# 	# Set combat as active button
# 	_set_active_nav_button(combat_btn)
# 	
# 	add_to_combat_log("[color=cyan]⚔️ Switched to Combat View[/color]")
