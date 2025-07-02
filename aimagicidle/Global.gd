extends RefCounted

# Global game data
static var player_level: int = 1
static var player_xp: int = 0
static var player_xp_needed: int = 100
static var player_hp: float = 100.0
static var player_max_hp: float = 100.0
static var player_mp: float = 50.0
static var player_max_mp: float = 50.0
static var player_gold: int = 0
static var player_skill_points: int = 0
static var player_str: int = 5
static var player_agi: int = 5
static var player_int: int = 5
static var player_vit: int = 5
static var player_spr: int = 5
static var current_location: String = "Forest"
static var monster_selected: int = 0

# Save/Load functions
static func save_game():
	var game_data = {
		"player_level": player_level,
		"player_xp": player_xp,
		"player_xp_needed": player_xp_needed,
		"player_hp": player_hp,
		"player_max_hp": player_max_hp,
		"player_mp": player_mp,
		"player_max_mp": player_max_mp,
		"player_gold": player_gold,
		"player_skill_points": player_skill_points,
		"player_str": player_str,
		"player_agi": player_agi,
		"player_int": player_int,
		"player_vit": player_vit,
		"player_spr": player_spr,
		"current_location": current_location,
		"monster_selected": monster_selected
	}
	
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(game_data))
	file.close()

static func load_game():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		var loaded = JSON.parse_string(data)
		if typeof(loaded) == TYPE_DICTIONARY:
			player_level = loaded.get("player_level", 1)
			player_xp = loaded.get("player_xp", 0)
			player_xp_needed = loaded.get("player_xp_needed", 100)
			player_hp = loaded.get("player_hp", 100.0)
			player_max_hp = loaded.get("player_max_hp", 100.0)
			player_mp = loaded.get("player_mp", 50.0)
			player_max_mp = loaded.get("player_max_mp", 50.0)
			player_gold = loaded.get("player_gold", 0)
			player_skill_points = loaded.get("player_skill_points", 0)
			player_str = loaded.get("player_str", 5)
			player_agi = loaded.get("player_agi", 5)
			player_int = loaded.get("player_int", 5)
			player_vit = loaded.get("player_vit", 5)
			player_spr = loaded.get("player_spr", 5)
			current_location = loaded.get("current_location", "Forest")
			monster_selected = loaded.get("monster_selected", 0)

# Getter/Setter functions
static func get_game_data(key: String, default_value = null):
	match key:
		"player_level": return player_level
		"player_xp": return player_xp
		"player_xp_needed": return player_xp_needed
		"player_hp": return player_hp
		"player_max_hp": return player_max_hp
		"player_mp": return player_mp
		"player_max_mp": return player_max_mp
		"player_gold": return player_gold
		"player_skill_points": return player_skill_points
		"player_str": return player_str
		"player_agi": return player_agi
		"player_int": return player_int
		"player_vit": return player_vit
		"player_spr": return player_spr
		"current_location": return current_location
		"monster_selected": return monster_selected
		_: return default_value

static func set_game_data(key: String, value):
	match key:
		"player_level": player_level = value
		"player_xp": player_xp = value
		"player_xp_needed": player_xp_needed = value
		"player_hp": player_hp = value
		"player_max_hp": player_max_hp = value
		"player_mp": player_mp = value
		"player_max_mp": player_max_mp = value
		"player_gold": player_gold = value
		"player_skill_points": player_skill_points = value
		"player_str": player_str = value
		"player_agi": player_agi = value
		"player_int": player_int = value
		"player_vit": player_vit = value
		"player_spr": player_spr = value
		"current_location": current_location = value
		"monster_selected": monster_selected = value
	
	save_game() 