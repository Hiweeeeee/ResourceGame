extends Node2D

signal house_entered

@onready var house_sprite = $HouseSprite
@onready var label = $Label
@onready var door_light = $DoorLight
@onready var window_light = $WindowLight


var is_on_door = false
var house_light_texture = preload("res://sprites/basic_house_light.png")

func _ready():
	door_light.hide()
	window_light.hide()

func _process(delta):
	if is_on_door == true and Input.is_action_just_pressed("interact"):
		house_entered.emit()
		house_sprite.texture = house_light_texture
		door_light.show()
		window_light.show()
		label.hide()
		

func _on_door_body_entered(body):
	is_on_door = true


func _on_door_body_exited(body):
	is_on_door = false
