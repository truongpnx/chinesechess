extends Rule
class_name HorseRule

const directions = [
	Vector2(1, 2),
	Vector2(-1, 2),
	Vector2(1, -2),
	Vector2(-1, -2),
	Vector2(-2, 1),
	Vector2(-2, -1),
	Vector2(2, 1),
	Vector2(2, -1),
]

const blocks = [
	Vector2(0, 1),
	Vector2(0, -1),
	Vector2(-1, 0),
	Vector2(1, 0),
]

func get_movable_pos(map: Array[Array], piece: Piece, pos: Vector2) -> Array[Vector2]:
	var movable: Array[Vector2] = []
	var next_pos: Vector2

	var num_blocks = len(blocks)
	for i in range(num_blocks):
		if _is_in_board(pos + blocks[i]) and _is_blocked(map, pos + blocks[i]):
			continue

		next_pos = pos + (directions[2*i] as Vector2)
		if _is_in_board(next_pos) and not _is_color_at_pos(map, next_pos, piece.color):
			movable.append(next_pos)

		next_pos = pos + (directions[2*i + 1] as Vector2)
		if _is_in_board(next_pos) and not _is_color_at_pos(map, next_pos, piece.color):
			movable.append(next_pos)
	return movable
