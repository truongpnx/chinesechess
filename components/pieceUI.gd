extends Button
class_name PieceUI

var data: Piece
var board_position: Vector2

signal piece_pressed(piece: PieceUI)

func _ready() -> void:
	pressed.connect(_on_pressed)

func update_UI(piece: Texture2D, character: Texture2D):
	%Sprite.texture = piece
	%Character.texture = character

func _on_pressed():
	piece_pressed.emit(self)

func flip_character(value: bool):
	if value:
		%Character.flip_h = true
		%Character.flip_v = true
