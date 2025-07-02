extends Control

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
@onready var player_skill_bar = $VBoxContainer/PlayerStats/PlayerActions/SkillBar

@onready var enemy_name_label = $VBoxContainer/EnemyInfo/EnemyName
@onready var enemy_hp_bar = $VBoxContainer/EnemyInfo/EnemyHPBar
@onready var enemy_hp_label = $VBoxContainer/EnemyInfo/EnemyHPBar/EnemyHPLabel
@onready var enemy_attack_bar = $VBoxContainer/EnemyInfo/EnemyActions/EnemyAttackBar
@onready var enemy_skill_bar = $VBoxContainer/EnemyInfo/EnemyActions/EnemySkillBar
@onready var respawn_timer_label = $VBoxContainer/EnemyInfo/RespawnTimer

@onready var combat_log = $VBoxContainer/CombatLog/ScrollContainer/LogText
@onready var reward_text = $VBoxContainer/LootDisplay/RewardText

func _ready():
	update_ui()
	add_to_combat_log("[color=yellow]Combat begins![/color]")
	
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
	add_to_combat_log("[color=lightblue]Player attacks for " + str(damage) + " damage![/color]")
	
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
	add_to_combat_log("[color=orange]Player casts Fireball for " + str(damage) + " damage![/color]")
	
	if enemy_hp <= 0:
		enemy_died()
	else:
		update_ui()

func enemy_basic_attack():
	if not enemy_alive:
		return
		
	var damage = enemy_damage + randi() % 4 - 1  # ±1 damage variance
	player_hp -= damage
	add_to_combat_log("[color=red]" + enemy_name + " attacks for " + str(damage) + " damage![/color]")
	
	if player_hp <= 0:
		player_hp = 1  # Player can't die in idle game
	
	update_ui()

func enemy_vicious_bite():
	if not enemy_alive:
		return
		
	var damage = (enemy_damage * 1.3) + randi() % 5 - 2  # 1.3x damage with variance
	player_hp -= damage
	add_to_combat_log("[color=darkred]" + enemy_name + " uses Vicious Bite for " + str(damage) + " damage![/color]")
	
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
	
	add_to_combat_log("[color=green]" + enemy_name + " dies![/color]")
	show_rewards(xp_reward, gold_reward)
	
	# Check for level up
	check_level_up()
	
	# Start respawn
	start_respawn()
	
	update_ui()

func show_rewards(xp_gain, gold_gain):
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
		
		add_to_combat_log("[color=gold]LEVEL UP! Now level " + str(player_level) + "![/color]")

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
		
		add_to_combat_log("[color=cyan]A new " + enemy_name + " appears! Player restored to full health![/color]")
		update_ui()
	else:
		# Update respawn timer display
		respawn_timer_label.text = "Next enemy in: " + str(int(ceil(respawn_timer))) + "s"

func update_ui():
	# Player stats
	level_label.text = "Level: " + str(player_level)
	gold_label.text = "Gold: " + str(player_gold)
	
	# XP progress bar
	xp_bar.max_value = player_xp_needed
	xp_bar.value = player_xp
	xp_bar_label.text = "XP: " + str(player_xp) + " / " + str(player_xp_needed)
	
	# HP bar
	hp_bar.max_value = player_max_hp
	hp_bar.value = player_hp
	hp_label.text = "HP: " + str(player_hp) + " / " + str(player_max_hp)
	
	# MP bar
	mp_bar.max_value = player_max_mp
	mp_bar.value = player_mp
	mp_label.text = "MP: " + str(player_mp) + " / " + str(player_max_mp)
	
	# Player action progress bars
	player_attack_bar.max_value = player_attack_cooldown
	player_attack_bar.value = player_attack_timer
	
	player_skill_bar.max_value = player_skill_cooldown
	player_skill_bar.value = player_skill_timer
	
	# Enemy info
	if enemy_alive:
		enemy_name_label.text = enemy_name + " Lv." + str(enemy_level)
		enemy_hp_bar.max_value = enemy_max_hp
		enemy_hp_bar.value = enemy_hp
		enemy_hp_label.text = "HP: " + str(enemy_hp) + " / " + str(enemy_max_hp)
		respawn_timer_label.text = ""
		
		# Enemy action progress bars
		enemy_attack_bar.max_value = enemy_attack_cooldown
		enemy_attack_bar.value = enemy_attack_timer
		
		enemy_skill_bar.max_value = enemy_skill_cooldown
		enemy_skill_bar.value = enemy_skill_timer
	else:
		enemy_name_label.text = enemy_name + " (Dead)"
		enemy_hp_bar.value = 0
		enemy_hp_label.text = "HP: 0 / " + str(enemy_max_hp)
		
		# Reset enemy action bars when dead
		enemy_attack_bar.value = 0
		enemy_skill_bar.value = 0

func add_to_combat_log(message):
	combat_log.append_text(message + "\n")
	
	# Limit log lines to prevent memory issues
	var lines = combat_log.get_parsed_text().split("\n")
	if lines.size() > 50:
		var limited_text = ""
		for i in range(lines.size() - 40, lines.size()):
			if i < lines.size():
				limited_text += lines[i] + "\n"
		combat_log.text = limited_text
