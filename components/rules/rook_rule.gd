extends Rule
class_name RookRule


const directions = [
	Vector2(0, 1),
	Vector2(0, -1),
	Vector2(1, 0),
	Vector2(-1, 0)
]

func get_movable_pos(map: Array[Array], piece: Piece, pos: Vector2) -> Array[Vector2]:
	var movable: Array[Vector2] = []

	for d: Vector2 in directions:
		var next_pos := pos + d
		while _is_in_board(next_pos):

			if map[next_pos.x][next_pos.y] is Piece:
				if map[next_pos.x][next_pos.y].color != piece.color:
					movable.append(next_pos)
				break
			else:
				movable.append(next_pos)
			next_pos += d
	
	return movable
