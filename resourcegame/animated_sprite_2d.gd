extends AnimatedSprite2D

func _ready():
	# Assuming the sprite's texture is already set and has a known height
	# Adjust offset to move the pivot to the bottom
	var sprite_height = texture.get_height()
	offset.y = sprite_height / 2 # Or -sprite_height / 2 depending on desired behavior

func _process(delta):
	# Example: Scale based on a variable (e.g., player health)
	# This assumes 'current_health' and 'max_health' are defined elsewhere
	# var scale_factor = float(current_health) / max_health
	# scale.y = scale_factor
	pass
