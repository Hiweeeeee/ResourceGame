extends CharacterBody2D

signal Redlight
signal Greenlight

@onready var sprite_2d = $Sprite2D
@onready var torch = $Torch
@onready var torch_light = $Torch/TorchLight
@onready var flashlight = $RotationPoint/Flashlight
@onready var flashlight_light = $RotationPoint/Flashlight/FlashlightLight
@onready var rotation_point = $RotationPoint
@onready var red_light = $RotationPoint/Flashlight/RedLight
@onready var green_light = $RotationPoint/Flashlight/GreenLight


const SPEED = 300.0
const ACCELERATION = 20.0
const DECELERATION = 60.0
const JUMP_VELOCITY = -600.0
const WALL_JUMP_VELOCITY = JUMP_VELOCITY * 0.8
const COYOTE_TIME = 0.1
var was_on_floor = false
var time_since_on_floor = 0.0
var wall_grab = false
var current_speed = 0.0:
	set(value):
		current_speed = clamp(value, -SPEED, SPEED)


func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	# Add the gravity.
	
	if not is_on_floor():
		#Track time since last on floor
		if time_since_on_floor >= COYOTE_TIME:
			was_on_floor = false
		else:
			time_since_on_floor += delta
	
	if not is_on_floor() and not is_on_wall():
		velocity += get_gravity() * delta
		wall_grab = false
		#Track time since last on floor
		if time_since_on_floor >= COYOTE_TIME:
			was_on_floor = false
		else:
			time_since_on_floor += delta
	#Reset time since last on floor
	elif is_on_floor():
		was_on_floor = true
		time_since_on_floor = 0.0
		
	elif is_on_wall():
		if wall_grab == false and velocity.y > 0:
			wall_grab = true
			velocity.y = 0
		elif velocity.y > 0:
			velocity += (get_gravity() * delta)/4
		else:
			velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and ((is_on_floor() or was_on_floor) or (is_on_wall() or wall_grab)):
		if (is_on_floor() or was_on_floor):
			velocity.y = JUMP_VELOCITY
		elif(is_on_wall() or wall_grab):
			var collision = get_slide_collision(1)
			if collision:
				var normal = collision.get_normal()
				# wall is on left side
				if normal.x > 0.5:
					velocity.y = WALL_JUMP_VELOCITY
					current_speed = -WALL_JUMP_VELOCITY
				# wall is on right side
				elif normal.x < -0.5:
					velocity.y = WALL_JUMP_VELOCITY
					current_speed = WALL_JUMP_VELOCITY
			
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
		current_speed += direction * ACCELERATION
		velocity.x = current_speed
		
		
	else:
		current_speed = lerp(current_speed, 0.0, .1)
		velocity.x = current_speed
	
	move_and_slide()
	
	if flashlight.visible == true:
		#flashlight rotation
		rotation_point.look_at(mouse_position)
		
		if Input.is_action_just_pressed("left_click") and (flashlight_light.visible or green_light.visible):
			flashlight_light.hide()
			green_light.hide()
			red_light.show()
			Redlight.emit()
		elif Input.is_action_just_pressed("left_click"):
			flashlight_light.show()
			red_light.hide()
			green_light.hide()
			Redlight.emit()
			
		if Input.is_action_just_pressed("right_click") and (flashlight_light.visible or red_light.visible):
			flashlight_light.hide()
			green_light.show()
			red_light.hide()
			Greenlight.emit()
		elif Input.is_action_just_pressed("right_click"):
			flashlight_light.show()
			red_light.hide()
			green_light.hide()
			Greenlight.emit()

func _on_eternal_torch():
	torch_light.energy = 2
	torch_light.texture_scale *= 3


func _on_house_entered():
	flashlight.show()
	torch.hide()
