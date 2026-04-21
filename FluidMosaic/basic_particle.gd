extends RigidBody2D

class_name BasicParticle

@export var speed = 200.0
var stasis = false
var freezer = false 
var variant = false
@onready var alt_texture = load("res://FluidMosaic/resources/Particulate.png")


func make_variant():

	$Sprite2D.texture = alt_texture

	
	
	variant = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	linear_velocity = random_direction * speed
	
	pass # Replace with function body.

func _integrate_forces(state):
	# Optional: Keep speed constant so they don't slow down over time
	if state.linear_velocity.length() > 0:
		if stasis == true:
			state.linear_velocity = state.linear_velocity.normalized() * speed/4
		#fuhreeezeeeee
		elif freezer == true:
			state.linear_velocity = state.linear_velocity.normalized() * 0	
		else:	
			state.linear_velocity = state.linear_velocity.normalized() * speed
		
func stasis_activate():
	#half as fast
	stasis = true
	
func stasis_disable():
	#back to normal
	stasis = false
	
func freeze_activate():
	freezer = true
	
func freeze_disable():
	freezer = false
	
	#type of particle determines direction
	if variant:
		var travel_direction = Vector2.UP
		linear_velocity = travel_direction * speed
	else:
		var travel_direction = Vector2.DOWN
		linear_velocity = travel_direction * speed
		
	
	 
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
