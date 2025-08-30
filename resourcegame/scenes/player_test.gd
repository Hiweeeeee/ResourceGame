extends Node2D
@onready var fireflies: GPUParticles2D = $"../GPUParticles2D2"

var shader : ShaderMaterial

func _ready() -> void:
	shader = fireflies.process_material;
	pass

func _process(delta: float) -> void:
	shader.set_shader_parameter("playerPosition", [position.x, position.y])
