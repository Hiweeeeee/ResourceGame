extends Node2D

var sticks = 0:
	set(value):
		sticks = clamp(value, 0, 100)

#@onready var stick_label = $"../Player/Camera2D/StickLabel"
@onready var stick_label = $"../HUD/StickLabel"
@onready var campfire = $"../Campfire"
#@onready var playerbody = $Playerbody
@onready var player = $"../Player/Playerbody"
@onready var house = $"../House"
@onready var hud = $"../HUD"

var shader : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	campfire.eternal_torch.connect(player._on_eternal_torch)
	house.house_entered.connect(player._on_house_entered)
	campfire.eternal_torch.connect(hud._on_eternal_torch)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("full_screen") and DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif Input.is_action_just_pressed("full_screen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func pick_up_stick():
	sticks += 1
	stick_label.text = "Sticks: " + str(sticks)

func put_down_stick():
	sticks -= 1
	stick_label.text = "Sticks: " + str(sticks)


func _on_quit_button_pressed():
	get_tree().quit()
	
