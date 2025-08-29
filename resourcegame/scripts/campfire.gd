extends Node2D

signal eternal_torch

@onready var game_manager = %GameManager
@onready var light = $Light
@onready var label = $Label


var sticks_fed = 0
var player_in_fire = false

func _ready():
	label.hide()

func _on_area_2d_body_entered(body):
	player_in_fire = true


func _on_area_2d_body_exited(body):
	player_in_fire = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and player_in_fire == true and game_manager.sticks != 0:
		game_manager.put_down_stick()
		light.energy += .5
		light.texture_scale += .2
		sticks_fed += 1
		
	if sticks_fed == 4:
		label.show()
		if Input.is_action_just_pressed("take_fire") and player_in_fire == true:
			eternal_torch.emit()
			# sticks fed = 5 so that label stays hiden again
			sticks_fed = 5
			label.hide()

			
