extends Node2D

class_name MembraneManager

#grab my phospholipid scene
@export var phospholipid_scene = preload("res://FluidMosaic/PhosUnit.tscn")
@export var unit_width: float = 32.0
@export var total_units: int = 60


var membrane_elements = [] # This stores references to all units (P-lipids and Proteins)

func _ready():
	#create as many as necessary as specified by the total_units variable
	for i in range(total_units):
		var p = phospholipid_scene.instantiate()
		add_child(p)
		membrane_elements.append(p)
	
	update_positions()

#Properly position lipids with an offset
func update_positions():
	var current_x = 0
	for element in membrane_elements:
		# Use a Tween for a "fluid" sliding effect
		var tw = create_tween()
		tw.tween_property(element, "position", Vector2(current_x, 0), 0.2).set_trans(Tween.TRANS_SINE)
		
		# If it's a protein, it might be wider than a phospholipid
		if element.has_method("get_unit_width"):
			current_x += element.get_unit_width()
		else:
			#currently added an offset of 3 for a better appearance visually, but its honestly pretty minor.
			#change as you see fit.
			current_x += unit_width + 3
			
func _process(delta: float) -> void:
	pass
