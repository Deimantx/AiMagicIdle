Prototype idler for claude to work with.

📱 Main Screen UI
Create a simple Main.tscn scene with the following UI elements:

Player Stats:

Level (e.g. Level: 1)

XP bar or XP label (e.g. XP: 0 / 100)

HP and MP bars (or labels)

Enemy Info:

Enemy name (e.g., "Wolf Lv.1")

Enemy HP bar

Combat Log:

Scrollable or auto-updating log showing combat events (e.g., “Player casts Fireball”)

Loot + XP Display:

Show "+5 XP" and "+10 Gold" on enemy defeat

Respawn Timer:

Countdown label (e.g., "Next enemy in: 4s")

⚔️ Combat System (Idle Style)
Combat starts automatically when the scene loads.

Attacks and skills happen based on cooldowns:

Player basic attack: every 2.5 seconds

Player skill – Fireball: every 3.5 seconds

Enemy (Wolf) basic attack: every 2.0 seconds

Enemy skill – Vicious Bite: every 2.5 seconds

Combat Timeline Example:
pgsql
Copy
Edit
1s  – No actions  
2s  – Wolf attacks  
2.5s – Player attacks + Wolf uses Vicious Bite  
3.5s – Player casts Fireball  
4s  – Wolf attacks  
5s  – Player attacks + Wolf uses Vicious Bite  
7s  – Player casts Fireball  
8s  – Wolf dies  
8–13s – Respawn delay  
13s – New Wolf spawns; player HP/MP restored
🎓 XP & Leveling System
Player gains XP each time a monster is defeated (e.g., +10 XP per kill).

XP needed to level up increases linearly (e.g., Level * 100 XP to next level).

On level-up:

Display “Level Up!” in combat log

Reset XP counter toward next level

Slightly increase stats (example):

+10 Max HP

+2 Damage per attack

+0.2 faster attack speed (optional)

💰 Loot System (Basic)
Each monster defeat gives:

Fixed gold amount (e.g., +10 gold)

Displayed in a label or floating text

Gold is stored and shown in the UI

🔁 Enemy Respawn System
After an enemy dies:

Wait 5 seconds

Respawn same enemy (Wolf) at full HP

Player HP/MP fully restored

🔧 Technical Notes
Use GDScript and Godot 4.4

Use Timer nodes or delta timers to manage attack/cast logic

Scene: one screen (Main.tscn) with all logic

Store XP, Level, Gold, and Stats in a basic Player script

✅ Features to Implement in This Prototype
✅ One working combat screen

✅ Player and Monster have timers for attacks and skills

✅ One skill: Fireball

✅ Basic combat log

✅ Monster respawn after death

✅ XP + Level-up system

✅ Stat growth when leveling

✅ Gold drop system

