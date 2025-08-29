extends Node2D
@onready var game_manager = %GameManager

var player_in_fire = false

func _on_area_2d_body_entered(body):
	player_in_fire = true


func _on_area_2d_body_exited(body):
	player_in_fire = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and player_in_fire == true:
		game_manager.put_down_stick()
