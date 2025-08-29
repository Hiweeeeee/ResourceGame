extends CanvasLayer

@onready var quit_button = $QuitButton
@onready var stick_label = $StickLabel
@onready var explain_menu = $ExplainMenu
@onready var explain_full_screen = $ExplainFullScreen

var menu_showing = false
var still_needs_sticks = true

func _process(delta):
	
	# hides the sticks label if you are done picking up sticks
	if still_needs_sticks == true and menu_showing == false:
		stick_label.show()
	else:
		stick_label.hide()
	# shows menu and hides non-menu labels
	if Input.is_action_just_pressed("menu") and menu_showing == false:
		menu_showing = true
		quit_button.show()
		explain_full_screen.show()
		stick_label.hide()
		explain_menu.hide()
	elif Input.is_action_just_pressed("menu"):
		menu_showing = false
		quit_button.hide()
		explain_full_screen.hide()
		if still_needs_sticks == true:
			stick_label.show()
		

func _on_eternal_torch():
	still_needs_sticks = false
