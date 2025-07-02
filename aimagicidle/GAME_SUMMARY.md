# AiMagicIdle - Idle Combat Game

## 🎮 Game Overview
A fully functional idle combat game built for Godot 4.4 based on the prototype specifications.

## ✅ Implemented Features

### 📱 Main Screen UI
- **Player Stats Display**: Level, XP progress bar, HP/MP bars, Gold counter
- **Enemy Information**: Enemy name with level, HP bar
- **Combat Log**: Scrollable log showing all combat events with color-coded messages
- **Loot Display**: Shows rewards (+XP, +Gold) when enemies are defeated
- **Respawn Timer**: Countdown showing when the next enemy will spawn

### ⚔️ Combat System (Fully Automated)
- **Player Attacks**:
  - Basic Attack: Every 2.5 seconds (15 base damage ±2 variance)
  - Fireball Skill: Every 3.5 seconds (1.5x damage, costs 10 MP)
- **Enemy Attacks**:
  - Wolf Basic Attack: Every 2.0 seconds (12 base damage ±1 variance)
  - Vicious Bite Skill: Every 2.5 seconds (1.3x damage)

### 🎓 XP & Leveling System
- **XP Rewards**: 10 + (enemy_level × 2) XP per kill
- **Level Requirements**: Level × 100 XP needed for next level
- **Stat Growth on Level Up**:
  - +10 Max HP (with full heal)
  - +3 Max MP (with full restore)
  - +2 Base damage

### 💰 Loot System
- **Gold Rewards**: 10 + (enemy_level × 3) Gold per kill
- **Reward Display**: Shows "+X XP, +Y Gold" for 3 seconds after each kill

### 🔁 Enemy Respawn System
- **Respawn Delay**: 5 seconds after enemy death
- **Full Restoration**: Player HP/MP fully restored on enemy respawn
- **Continuous Combat**: New Wolf Lv.1 spawns automatically

## 🎯 Game Mechanics

### Combat Timeline Example:
```
0s    - Combat begins
2.0s  - Wolf attacks player
2.5s  - Player basic attack + Wolf vicious bite
3.5s  - Player casts Fireball (if MP available)
4.0s  - Wolf attacks player
5.0s  - Player basic attack + Wolf vicious bite
7.0s  - Player casts Fireball
~8s   - Wolf dies, rewards shown
8-13s - Respawn timer countdown
13s   - New Wolf spawns, player fully healed
```

### Player Progression:
- **Level 1**: 100 HP, 50 MP, 15 damage
- **Level 2**: 110 HP, 53 MP, 17 damage  
- **Level 3**: 120 HP, 56 MP, 19 damage
- And so on...

## 🚀 How to Run

### Prerequisites:
- Godot Engine 4.4+ installed

### Running the Game:
1. Open Godot Engine
2. Click "Import" and select the `project.godot` file
3. Click "Import & Edit"
4. Press F5 or click the "Play" button
5. Select `Main.tscn` as the main scene when prompted

### Or via Command Line:
```bash
cd aimagicidle
godot
```

## 🎨 UI Layout

The game features a clean, mobile-friendly vertical layout:

1. **Player Stats Section** (Top)
   - Level and XP progress
   - HP bar (red) with overlay text
   - MP bar (blue) with overlay text  
   - Gold counter

2. **Enemy Section** (Middle)
   - Enemy name and level
   - Enemy HP bar (red) with overlay text
   - Respawn timer (yellow text)

3. **Combat Log** (Center - Expandable)
   - Scrollable colored combat messages
   - Auto-scrolls to newest messages
   - Limited to 50 lines for performance

4. **Rewards Section** (Bottom)
   - Green text showing recent XP/Gold gains
   - Auto-clears after 3 seconds

## 🔧 Technical Details

- **Engine**: Godot 4.4.1
- **Scripting**: GDScript
- **Architecture**: Single scene (`Main.tscn`) with main controller script (`Main.gd`)
- **Resolution**: 720×1280 (Mobile portrait)
- **Rendering**: Mobile renderer for performance

## 🎮 Game Flow

1. **Start**: Player begins at Level 1 facing Wolf Lv.1
2. **Combat**: Automatic attacks based on cooldown timers
3. **Victory**: Wolf dies, player gains XP/Gold
4. **Level Up**: Stats increase when XP threshold reached
5. **Respawn**: 5-second countdown, then new Wolf appears
6. **Repeat**: Endless idle combat loop

The game is fully functional and matches all specifications from the original prototype requirements!