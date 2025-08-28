extends Node2D

var sticks = 0

@onready var stick_label = $"../Player/Camera2D/StickLabel"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pick_up_stick():
	sticks += 1
	stick_label.text = "Sticks: " + str(sticks)
