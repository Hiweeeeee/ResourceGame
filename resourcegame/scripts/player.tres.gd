extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var torch = $Torch
@onready var torch_light = $Torch/TorchLight



const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const COYOTE_TIME = 0.1
var was_on_floor = false
var time_since_on_floor = 0.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		#Track time since last on floor
		if time_since_on_floor >= COYOTE_TIME:
			was_on_floor = false
		else:
			time_since_on_floor += delta
	#Reset time since last on floor
	elif is_on_floor():
		was_on_floor = true
		time_since_on_floor = 0.0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or was_on_floor):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	# turn the sprite
	if direction > 0:
		sprite_2d.flip_h = false
		torch.flip_h = false
		torch.position = Vector2(12, -1)
	elif direction < 0:
		sprite_2d.flip_h = true
		torch.flip_h = true
		torch.position = Vector2(-12, -1)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	move_and_slide()


func _on_eternal_torch():
	torch_light.energy = 2.5
	torch_light.texture_scale *= 3
