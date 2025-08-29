extends Node2D


@onready var game_manager = %GameManager
@onready var light = $Light



var player_in_fire = false

func _on_area_2d_body_entered(body):
	player_in_fire = true


func _on_area_2d_body_exited(body):
	player_in_fire = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and player_in_fire == true and game_manager.sticks != 0:
		game_manager.put_down_stick()
		light.energy += .5
		light.texture_scale += .2
