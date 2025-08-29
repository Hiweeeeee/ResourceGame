extends Node2D

var sticks = 0:
	set(value):
		sticks = clamp(value, 0, 100)

#@onready var stick_label = $"../Player/Camera2D/StickLabel"
@onready var stick_label = $"../HUD/StickLabel"
@onready var campfire = $"../Campfire"
#@onready var playerbody = $Playerbody
@onready var player = $"../Player/Playerbody"

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	campfire.eternal_torch.connect(player._on_eternal_torch)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pick_up_stick():
	sticks += 1
	stick_label.text = "Sticks: " + str(sticks)

func put_down_stick():
	sticks -= 1
	stick_label.text = "Sticks: " + str(sticks)
