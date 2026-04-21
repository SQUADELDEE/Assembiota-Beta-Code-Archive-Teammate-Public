extends Node2D

var particle_max = 35
@onready var particlespawner = $ParticleSpawner

@onready var part_scene: PackedScene = preload("res://FluidMosaic/BasicParticle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_particles()
	pass # Replace with function body.

func spawn_particles():
	for i in range(particle_max):
		var particle = part_scene.instantiate()
		particlespawner.add_child(particle)
		if i > (particle_max/2):
			#change it to a hexagon
			particle.make_variant()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
