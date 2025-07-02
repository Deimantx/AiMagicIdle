extends Control

# This script will draw lines between equipment slots in the EquipmentGrid.
# You can update the slot names and connections as needed.

func _draw():
    var grid = get_parent().get_node("EquipmentGrid")
    # Example: Draw a line from Weapon to Armor slot
    var weapon_slot = grid.get_node("Slot_Weapon")
    var armor_slot = grid.get_node("Slot_Armor")
    var weapon_pos = weapon_slot.get_global_rect().position + weapon_slot.get_global_rect().size / 2
    var armor_pos = armor_slot.get_global_rect().position + armor_slot.get_global_rect().size / 2
    draw_line(to_local(weapon_pos), to_local(armor_pos), Color(0.7, 0.7, 0.8), 2)
    # Add more draw_line calls for other connections as needed

func _ready():
    update() # Redraw when ready 