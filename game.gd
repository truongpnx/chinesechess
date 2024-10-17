extends Control
class_name GameManager

const button_sfx = preload("res://assets/audios/Retro Water Drop 01.wav")

@onready var menu: Control = $Menu
@onready var options: Control = $Options
@onready var chessboard_ui: Control = $ChessboardUI
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

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
	play_sfx(button_sfx)
	previous_ui_type.append(from)
	show_ui(to)

func go_back():
	play_sfx(button_sfx)
	
	var ui_type = previous_ui_type.pop_back()
	if ui_type != null:
		return show_ui(ui_type)
	get_tree().quit()


func play_sfx(stream: AudioStream):
	sfx_player.stream = stream
	sfx_player.play()
	await sfx_player.finished

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST:
			go_back()
