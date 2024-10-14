extends Rule
class_name ElephantRule


const directions = [
	Vector2(1, 1),
	Vector2(1, -1),
	Vector2(-1, 1),
	Vector2(-1, -1),
]

func get_movable_pos(map: Array[Array], piece: Piece, pos: Vector2) -> Array[Vector2]:
	var movable: Array[Vector2] = []

	for d in directions:
		if _is_in_board(pos + d) and _is_blocked(map, pos + d):
			continue
		
		var next_pos = pos + 2 * d
		if _is_in_region(next_pos, piece.color) and not _is_color_at_pos(map, next_pos, piece.color):
			movable.append(next_pos)
	
	return movable

func _is_in_region(pos: Vector2, color: Piece.COLOR):
	if _is_in_board(pos):
		var region = Board.RED_REGION if color== Piece.COLOR.Red else Board.BLACK_REGION
		return (pos.x >= region[0] and pos.x <= region[1])
	return false
