extends BaseUI

signal end_game

@export_group("Apperence Data")
@export var piece_set_holder: PieceSetHolder
@export var characters_collection_holder: CharacterCollectionHolder
@export var piece_scene: PackedScene

@export_group("Container Node")
@export var marker_map: Control
@export var piece_container: Control

@export_group("Logic Node")
@export var board: Board

@export_group("Transition Effect")
@export var move_time: float = 0.5

var red_pieces_UI: Array[PieceUI] = []
var black_pieces_UI: Array[PieceUI] = []
var current_pick: PieceUI
var previous_state: Array[BoardState] = []


var piece_set_idx: int = 0
var character_set_idx: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	SignalBus.board_settings_updated.connect(_on_board_settings_update)
	_assign_marker_data()

	_reset()

func _reset():
	previous_state.clear()

	board.reset()
	_draw_board()

func _assign_marker_data():
	for i in range(board.MAX_HEIGHT + 1):
		for j in range(board.MAX_WIDTH + 1):
			var marker = marker_map.get_children()[i].get_children()[j] as MarkerButton
			marker.add_data(Vector2(i, j))
			marker.data_transfered.connect(_on_marker_trigger)

## Should call when board's state change except move() 
func _draw_board():
	for child in piece_container.get_children():
		child.queue_free()
	
	red_pieces_UI.clear()
	black_pieces_UI.clear()

	for i in range(board.MAX_HEIGHT + 1):
		for j in range(board.MAX_WIDTH + 1):
			if board.state.map[i][j] is Piece:
				var ui = piece_scene.instantiate() as PieceUI
				ui.data = board.state.map[i][j]
				ui.board_position = Vector2(i, j)

				piece_container.add_child(ui)
				var marker = marker_map.get_children()[i].get_children()[j] as MarkerButton
				ui.global_position = marker.global_position + marker.size / 2 - ui.size / 2
				
				if ui.data.color == Piece.COLOR.Red:
					ui.flip_character(true)
					red_pieces_UI.append(ui)
				else:
					black_pieces_UI.append(ui)
				ui.piece_pressed.connect(_on_piece_pressed)

	_update_UI()

func _update_UI():
	_update_piece_UI(red_pieces_UI)
	_update_piece_UI(black_pieces_UI)

func _update_piece_UI(pieces_UI: Array[PieceUI]):
	for piece in pieces_UI:
		var piece_sprite: Texture2D
		
		match piece.data.color:
			Piece.COLOR.Red:
				piece_sprite = piece_set_holder.get_set(piece_set_idx).red_texture
			Piece.COLOR.Black:
				piece_sprite = piece_set_holder.get_set(piece_set_idx).black_texture
		
		var character_data := characters_collection_holder \
								.get_collection(character_set_idx) \
								.get_data_of_piece_name(0, piece.data.name)
		
		piece.update_UI(piece_sprite, character_data.texture)

func _on_marker_trigger(pos: Vector2):
	if current_pick:
		move(current_pick, pos)

func _on_piece_pressed(piece: PieceUI):

	if current_pick and piece.data.color != board.state.current_turn:
		move(current_pick, piece.board_position)
		
	elif piece.data.color == board.state.current_turn:
		current_pick = piece

func move(piece: PieceUI, marker_indices: Vector2):
	current_pick = null

	if not board.is_valid_move(board.state, piece.board_position, marker_indices):
		return
	
	_set_enable_piece(black_pieces_UI, false)
	_set_enable_piece(red_pieces_UI, false)
	
	var global_target_pos = _get_marker_global_position(marker_indices) - piece.size / 2
	var tween = create_tween()
	tween.tween_property(piece, "z_index", 5, 0.0)
	tween.tween_property(piece, "global_position", global_target_pos, move_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(piece, "z_index", 0, 0.0)
	
	await  tween.finished
	
	var uis = black_pieces_UI if piece.data.color == Piece.COLOR.Red else red_pieces_UI
	var idx = 0
	for ui: PieceUI in uis:
		if ui.board_position == marker_indices:
			ui.queue_free()
			uis.remove_at(idx)
			break
		idx += 1
	
	previous_state.append(board.state.duplicate())
	board.move(board.state, piece.board_position, marker_indices)

	piece.board_position = marker_indices
	
	if board.state.end_game:
		print("End")
		end_game.emit()


func undo():
	var state = previous_state.pop_back()
	if state:
		board.state = state
		_draw_board()

func _get_marker_global_position(marker_indices: Vector2):
	var marker = marker_map.get_child(int(marker_indices.x)).get_child(int(marker_indices.y)) as MarkerButton
	return marker.global_position + marker.size/2

func _set_enable_piece(piece_set: Array[PieceUI], value: bool):
	for piece: PieceUI in piece_set:
		piece.set_deferred("disabled", value)

func _on_board_settings_update(_piece_set_idx: int, _character_set_idx: int):
	piece_set_idx = _piece_set_idx
	character_set_idx = _character_set_idx
	_update_UI()
	
