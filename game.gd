extends Control
class_name GameManager

@onready var menu: Control = $Menu
@onready var options: Control = $Options
@onready var chessboard_ui: Control = $ChessboardUI

enum UI_TYPE {Menu, Options, Chessboard}

var previous_ui_type: Array[UI_TYPE] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is BaseUI:
			child.parent = self
	
	show_ui(UI_TYPE.Menu)

func show_ui(ui_type: UI_TYPE):
	menu.visible = false
	options.visible = false
	chessboard_ui.visible = false
	
	match ui_type:
		UI_TYPE.Menu:
			menu.visible = true
		UI_TYPE.Options:
			options.visible = true
		UI_TYPE.Chessboard:
			chessboard_ui.visible = true

func go_to(from: UI_TYPE, to: UI_TYPE):
	previous_ui_type.append(from)
	show_ui(to)

func go_back():
	var ui_type = previous_ui_type.pop_back()
	if ui_type:
		return show_ui(ui_type)
	
	get_tree().quit()
