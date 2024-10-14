extends Rule
class_name AdvisorRule


const directions = [
	Vector2(1, 1),
	Vector2(1, -1),
	Vector2(-1, 1),
	Vector2(-1, -1),
]

func get_movable_pos(map: Array[Array], piece: Piece, pos: Vector2) -> Array[Vector2]:
	var movable: Array[Vector2] = []
	for d: Vector2 in directions:
		var next_pos := pos + d
		if _is_in_board(next_pos) and not _is_color_at_pos(map, next_pos, piece.color) and _is_in_range(piece, next_pos):
			movable.append(next_pos)
	
	return movable

func _is_in_range(advisor: Piece, pos: Vector2) -> bool:
	var left = 3
	var right = 5
	var top = 0
	var down = 2
	
	if advisor.color == Piece.COLOR.Black:
		top = 7
		down = 9
	
	return (left <= pos.y and pos.y <= right) and (top <= pos.x and pos.x <= down) 
	
	
