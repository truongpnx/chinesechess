extends Rule
class_name CannonRule

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
			if _is_blocked(map, next_pos):
				var target_pos = _find_target(map, piece.color, d, next_pos)
				if target_pos:
					movable.append(target_pos)
				break
			else:
				movable.append(next_pos)
			next_pos += d
	
	return movable

func _find_target(map: Array[Array], color: Piece.COLOR, direction: Vector2, fulcrum: Vector2):
	var next_pos = fulcrum + direction
	while _is_in_board(next_pos):
		if _is_blocked(map, next_pos) and map[next_pos.x][next_pos.y].color != color:
			return next_pos
		next_pos += direction
	return null
