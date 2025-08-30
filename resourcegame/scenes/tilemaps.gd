extends Node

@onready var mid = $NormalTileset/MidTileMap/Mid
@onready var background = $NormalTileset/BackgroundTileMap/Background
@onready var red_mid = $RedTileset/RedMidTileMap/RedMid
@onready var blood_treasure = $GreenTileset/GreenMidTileMap/BloodTreasure
@onready var red_background = $RedTileset/RedBackgroundTileMap/RedBackground
@onready var green_mid = $GreenTileset/GreenMidTileMap/GreenMid

func _ready():
	mid.enabled = true
	mid.visible = true
	background.enabled = true
	background.visible = true
	red_mid.enabled = false
	red_mid.visible = true
	blood_treasure.enabled = false
	blood_treasure.visible = true
	red_background.enabled = false
	red_background.visible = false
	green_mid.enabled = false
	green_mid.visible = true

# for right now I am just going to always keep normal background on until I find a real reason to
# have red or green background take over
func _on_red_light():
	# turning light to red 
	if red_mid.enabled == false:
		red_mid.enabled = true
		blood_treasure.enabled = false
		green_mid.enabled = false
		mid.enabled = false
		
	# turning light to white
	elif red_mid.enabled == true:
		mid.enabled = true
		red_mid.enabled = false
		blood_treasure.enabled = false
		green_mid.enabled = false


func _on_green_light():
	# turning light to green
	if green_mid.enabled == false:
		red_mid.enabled = false
		blood_treasure.enabled = true
		green_mid.enabled = true
		mid.enabled = true

	# turning light to white
	elif green_mid.enabled == true:
		mid.enabled = true
		red_mid.enabled = false
		green_mid.enabled = false
		blood_treasure.enabled = true
