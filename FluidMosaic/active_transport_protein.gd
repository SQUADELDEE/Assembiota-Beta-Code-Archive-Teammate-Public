extends Node2D
var standard_quota = 0
var variant_quota = 0

@export var transit_speed = 150.0
var dragging = false
var draggable = true
var drag_offset = Vector2.ZERO
@onready var area = $PartGrabber
var busy = false

@onready var particle_storage = []

@onready var standard_texture = load("res://FluidMosaic/resources/ActiveTransporter.png")
@onready var sprite = $PartGrabber/Sprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not area.input_event.is_connected(_on_area_2d_input_event):
		area.input_event.connect(_on_area_2d_input_event)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
		for particle in particle_storage:
			
			particle.freeze_disable()
			
		
		#empty storage units
		particle_storage = []
		standard_quota = 0
		variant_quota = 0
		return
		
		
	if standard_quota >= 1 and variant_quota >= 2:
		print(len(particle_storage))
		for particle in particle_storage:
			
			particle.freeze_disable()
			
		
		#empty storage units
		particle_storage = []
		standard_quota = 0
		variant_quota = 0
				
		
	pass
	

	
	
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

#STARTING TO GET HEAVYWEIGHT-------------------------------------------



#SECTION ONE (HANDLING PARTICLE GRABS FOR TWO WAY PARTICLES)
func _on_part_grabber_body_entered(body: Node2D) -> void:
	
	
	if body is BasicParticle:
		#only permit orange particles that are moving upwards to enter
		if body.variant and body.linear_velocity.y < 0 and variant_quota < 2:
			body.set_collision_mask_value(1, false)
			var travel_direction = Vector2.UP
			body.linear_velocity = travel_direction * transit_speed
			pass
		#only permit standard particles that are moving downwards to enter
		elif not body.variant and body.linear_velocity.y > 0 and standard_quota < 2:
			body.set_collision_mask_value(1, false)
			var travel_direction = Vector2.DOWN 
			body.linear_velocity = travel_direction * transit_speed
			pass
			




func _on_part_grabber_body_exited(body: Node2D) -> void:
	if body is BasicParticle:
		# Re-enable the membrane collision so it stays on the new side
		body.set_collision_mask_value(1, true)


#-------------------------------------------------------------------


#SECTION TWO (UPPER MERIDIAN)
#Objective-- Hold particles that enter from the upper portion still
func _on_upper_meridian_body_entered(body: Node2D) -> void:
	if body is BasicParticle and not body.variant:
		#replace stasis with a complete freeze
		body.freeze_activate()
		standard_quota += 1
		particle_storage.append(body)
	pass # Replace with function body.


func _on_upper_meridian_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

#-----------------------------------------------


#SECTION THREE (LOWER MERIDIAN)
#Objective-- Hold particles ascending from the lower portion, and lock them in place
func _on_lower_meridian_body_entered(body: Node2D) -> void:
	if body is BasicParticle and body.variant:
		#replace stasis with a complete freeze
		body.freeze_activate()
		variant_quota += 1
		particle_storage.append(body)
		
	pass # Replace with function body.


func _on_lower_meridian_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
	
#----------------------------------------------
