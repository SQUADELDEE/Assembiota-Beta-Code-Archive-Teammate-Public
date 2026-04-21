extends Node2D

class_name ProteinChannelBasic

@export var transit_speed = 150.0
var dragging = false
var draggable = true
var drag_offset = Vector2.ZERO
@onready var area = $ProtienBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if not area.input_event.is_connected(_on_area_2d_input_event):
		area.input_event.connect(_on_area_2d_input_event)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
		return
	pass


func _on_protien_body_body_entered(body: Node2D) -> void:
	
	#dont permit orange guys
	if body is BasicParticle and not body.variant:
	

	#Disable its collision with the membrane (Layer 1)
		body.set_collision_mask_value(1, false)
		
	#Suck into the center of the channel for a clean pass
	
	#push straight down or straight up depending on value
		if body.linear_velocity.y > 0:
			var travel_direction = Vector2.DOWN 
			body.linear_velocity = travel_direction * transit_speed
		elif body.linear_velocity.y < 0:
			var travel_direction = Vector2.UP
			body.linear_velocity = travel_direction * transit_speed



		
	
	pass # Replace with function body.


func _on_protien_body_body_exited(body: Node2D) -> void:
	if body is BasicParticle and not body.variant:
		# Re-enable the membrane collision so it stays on the new side
		body.set_collision_mask_value(1, true)
	pass # Replace with function body.
	
	

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not draggable: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
			
			get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			# Resume the organic pulse when dropped
