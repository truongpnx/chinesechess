extends Rule
class_name KingRule

const directions = {
	"down_right": Vector2(1, 1),
	"down_left": Vector2(1, -1),
	"up_right": Vector2(-1, 1),
	"up_left": Vector2(-1, -1),
	"right": Vector2(0, 1),
	"left": Vector2(0, -1),
	"up": Vector2(-1, 0),
	"down": Vector2(1, 0),
}

const directions_map = {
	Vector2(0, 0): [
		directions['down'],
		directions['right'],
		directions['down_right']
	], 
	Vector2(0, 1): [
		directions['left'],
		directions['right'],
		directions['down']
	],
	Vector2(0, 2): [
		directions['left'],
		directions['down_left'],
		directions['down']
	],
	Vector2(1, 0): [
		directions['up'],
		directions['down'],
		directions['right']
	], 
	Vector2(1, 1): [
		directions['up'],
		directions['down'],
		directions['left'],
		directions['right'],
		directions['up_left'],
		directions['up_right'],
		directions['down_left'],
		directions['down_right']
	], 
	Vector2(1, 2): [
		directions['left'],
		directions['up'],
		directions['down']
	],
	Vector2(2, 0): [
		directions['up'],
		directions['right'],
		directions['up_right']
	], 
	Vector2(2, 1): [
		directions['up'],
		directions['right'],
		directions['left']
	], 
	Vector2(2, 2): [
		directions['up_left'],
		directions['up'],
		directions['right']
	], 
}


func get_movable_pos(map: Array[Array], piece: Piece, pos: Vector2) -> Array[Vector2]:
	var movable: Array[Vector2] = []
	var direct = directions_map[_get_pos_in_palace(piece, pos)]
	
	for d: Vector2 in direct:
		var next_pos := pos + d
		if _is_in_board(next_pos) and not _is_color_at_pos(map, next_pos, piece.color) and _is_in_range(piece, next_pos):
			movable.append(next_pos)
	var target_pos = _face_other_king(piece, pos, map)
	if target_pos:
		movable.append(target_pos as Vector2)
	
	return movable

func _is_in_range(king: Piece, pos: Vector2) -> bool:
	var left = 3
	var right = 5
	var top = 0
	var down = 2
	
	if king.color == Piece.COLOR.Black:
		top = 7
		down = 9
	
	return (left <= pos.y and pos.y <= right) and (top <= pos.x and pos.x <= down) 

func _get_pos_in_palace(king: Piece, king_pos: Vector2) -> Vector2:
	var left = 3
	var top = 0
	
	if king.color == Piece.COLOR.Black:
		top = 7

	return king_pos - Vector2(top, left)

func _face_other_king(king: Piece, king_pos: Vector2, map: Array[Array]):
	var direction = Vector2(1, 0) if king.color == Piece.COLOR.Red else Vector2(-1, 0)
	var next_pos = king_pos + direction
	while _is_in_board(next_pos):
		if _is_blocked(map, next_pos):
			if map[next_pos.x][next_pos.y].name == Piece.NAME.King:
				return next_pos
			break
		next_pos += direction
	
	return null
