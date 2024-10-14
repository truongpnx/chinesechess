extends Rule
class_name PawnRule

const directions = [
	Vector2(0, 1),
	Vector2(0, -1),
	Vector2(1, 0),
	Vector2(-1, 0)
]

func get_movable_pos(map: Array[Array], piece: Piece, pos: Vector2) -> Array[Vector2]:
	var movable: Array[Vector2] = []
	var vertical_d := directions[2] if piece.color == Piece.COLOR.Red else directions[3]
	
	if _is_in_board(pos + vertical_d):
		movable.append(pos + vertical_d)
	
	if _crossed_river(piece, pos):
		for d in [directions[0], directions[1]]:
			var next_pos = pos + d
			if _is_in_board(next_pos) and not _is_color_at_pos(map, next_pos, piece.color):
				movable.append(next_pos)
	return movable

func _crossed_river(pawn: Piece, pos: Vector2) -> bool:
	if pawn.color == Piece.COLOR.Red:
		return Board.BLACK_REGION[0] <= pos.x and pos.x <= Board.BLACK_REGION[1]
	elif pawn.color == Piece.COLOR.Black:
		return Board.RED_REGION[0] <= pos.x and pos.x <= Board.RED_REGION[1]
	return false
