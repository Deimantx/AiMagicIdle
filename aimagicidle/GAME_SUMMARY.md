# AiMagicIdle - Idle Combat Game

## 🎮 Game Overview
A fully functional idle combat game built for Godot 4.4 based on the prototype specifications.

**Last Updated:** Latest enhancements include enhanced combat log colors, persistent bottom navigation, and improved mobile UI layout.

## ✅ Implemented Features

### 📱 Enhanced Main Screen UI
- **Player Stats Display**: 
  - Level indicator
  - XP progress bar (yellow) with overlay text showing current/needed XP
  - Wider HP bar (red, 30px height) with overlay text
  - Wider MP bar (blue, 30px height) with overlay text and regeneration (1/sec)
  - Gold counter
- **Player Action Bars**:
  - Attack cooldown progress bar (light red, 2.5s cycle)
  - Fireball skill cooldown progress bar (orange, 3.5s cycle)
- **Enemy Information**: 
  - Enemy name with level
  - Wider enemy HP bar (red, 30px height)
- **Enemy Action Bars**:
  - Wolf Attack cooldown progress bar (dark red, 2.0s cycle)
  - Vicious Bite skill cooldown progress bar (darker red, 2.5s cycle)
- **Enhanced Combat Log**: 
  - Rich colored messages with emojis for better visual distinction
  - **Green**: Player damage dealt (💥 Attack, 🔥 Fireball)
  - **Yellow**: Damage numbers and rewards
  - **Light Coral/Crimson**: Enemy attacks and player damage taken  
  - **Red**: Damage values when taking damage
  - **Gold**: Level up announcements with stat gains
  - **Cyan**: System messages and navigation feedback
- **Loot Display**: Shows rewards (+XP, +Gold) when enemies are defeated
- **Respawn Timer**: Countdown showing when the next enemy will spawn
- **🔥 Persistent Bottom Navigation Bar**: Always visible quick access menu

### ⚔️ Combat System (Fully Automated)
- **Player Attacks**:
  - Basic Attack: Every 2.5 seconds (15 base damage ±2 variance)
  - Fireball Skill: Every 3.5 seconds (1.5x damage, costs 10 MP)
  - MP Regeneration: 1 MP per second (automatic)
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

### 🧭 Bottom Navigation System
- **Persistent UI**: Always visible at bottom of screen (80px height)
- **5 Quick Access Buttons**:
  - **⚔️ Combat**: Current combat view (highlighted when active)
  - **🛡️ Hero**: Character stats & equipment panel (placeholder)
  - **🎒 Inventory**: Items, weapons, armor management (placeholder)
  - **⭐ Skills**: Skill tree & ability upgrades (placeholder)  
  - **🏪 Shop**: Purchase items with gold (placeholder)
- **Visual Feedback**: Active button highlighted in cyan, others in white
- **Interactive Placeholders**: Clicking buttons shows "Coming Soon" messages in combat log

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

## 🎨 Enhanced UI Layout

The game features a modern, mobile-friendly layout with scrollable content and persistent navigation:

### **Main Container Structure:**
- **Scrollable Game Content** (Expandable - takes most screen space)
- **Fixed Bottom Navigation** (80px height - always visible)

### **Scrollable Content Areas:**

1. **Player Stats Section** (Top)
   - Level indicator
   - XP progress bar (25px height, yellow) showing level progression
   - HP bar (30px height, red) with overlay text
   - MP bar (30px height, blue) with overlay text and automatic regeneration
   - Gold counter
   - **Action Progress Bars**:
     - Attack cooldown (20px height, light red)
     - Fireball skill cooldown (20px height, orange)

2. **Enemy Section** (Middle)
   - Enemy name and level
   - Enemy HP bar (30px height, red) with overlay text
   - **Enemy Action Progress Bars**:
     - Wolf Attack cooldown (20px height, dark red)
     - Vicious Bite skill cooldown (20px height, darker red)
   - Respawn timer (yellow text)

3. **Enhanced Combat Log** (Center - Expandable)
   - Rich text with emojis and color coding
   - **Damage dealt**: Green with 💥⚔️🔥 icons
   - **Damage received**: Red/Coral with ⚔️🩸 icons  
   - **System events**: Cyan/Yellow/Gold with 💀💰⭐🐺 icons
   - Auto-scrolls to newest messages
   - Limited to 50 lines for performance

4. **Rewards Section**
   - Green text showing recent XP/Gold gains
   - Auto-clears after 3 seconds

5. **Bottom Navigation Bar** (Always Visible)
   - Dark semi-transparent background
   - 5 equally-spaced icon buttons with labels
   - Visual feedback for active menu
   - Responsive button highlighting

### 📊 Real-Time Progress Visualization
All progress bars update in real-time every frame, providing immediate visual feedback for:
- XP progression towards next level
- Player attack/skill cooldowns
- Enemy attack/skill cooldowns  
- HP/MP levels with regeneration
- Combat timing and action predictions

## 🔧 Technical Details

- **Engine**: Godot 4.4.1
- **Scripting**: GDScript
- **Architecture**: Single scene (`Main.tscn`) with main controller script (`Main.gd`)
- **Resolution**: 720×1280 (Mobile portrait)
- **Rendering**: Mobile renderer for performance

## 🎮 Enhanced Game Flow

1. **Start**: Player begins at Level 1 facing Wolf Lv.1
2. **Combat**: Automatic attacks based on cooldown timers with real-time progress bars
3. **Rich Feedback**: Colorful combat log with emojis showing all actions
4. **Victory**: Wolf dies, player gains XP/Gold with detailed reward messages
5. **Level Up**: Stats increase with clear progression announcements
6. **Navigation**: Use bottom menu to explore different game sections (placeholders)
7. **Respawn**: 5-second countdown, then new Wolf appears with full restoration
8. **Repeat**: Endless idle combat loop with comprehensive visual feedback

## 🆕 Latest Enhancements

### ✨ **Enhanced Combat Log Colors & Emojis:**
- **💥 Player Attacks**: Green with yellow damage numbers
- **🔥 Player Skills**: Orange with yellow damage numbers  
- **⚔️ Enemy Attacks**: Light coral with red damage to player
- **🩸 Enemy Skills**: Crimson with red damage to player
- **💀 Enemy Deaths**: Green defeat messages
- **💰 Rewards**: Yellow XP/Gold gain messages
- **⭐ Level Ups**: Gold announcements with stat details
- **🐺 Respawns**: Cyan enemy appearance messages

### 🧭 **Persistent Bottom Navigation:**
- **Always Visible**: 80px navigation bar never disappears
- **5 Menu Buttons**: Combat, Hero, Inventory, Skills, Shop
- **Visual Feedback**: Active button highlighted in cyan
- **Future-Ready**: Placeholder functionality for game expansion
- **Interactive**: Click buttons to see planned features in combat log

### 📱 **Improved Mobile Layout:**
- **Scrollable Content**: Main game area scrolls if content exceeds screen
- **Fixed Navigation**: Bottom bar always accessible
- **Responsive Design**: Adapts to different screen sizes
- **Professional UI**: Modern game interface with proper spacing

The game now provides a complete idle combat experience with professional-grade UI and rich visual feedback!