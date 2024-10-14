extends RefCounted
class_name Rule

func _is_in_board(pos: Vector2) -> bool:
	return (pos.x >= 0 and pos.x <= Board.MAX_HEIGHT) \
		and (pos.y >= 0 and pos.y <= Board.MAX_WIDTH)

func _is_blocked(map: Array[Array], pos: Vector2) -> bool:
	return map[pos.x][pos.y] is Piece

func _is_color_at_pos(map: Array[Array], pos: Vector2, color: Piece.COLOR) -> bool:
	if map[pos.x][pos.y] is Piece:
		return color == map[pos.x][pos.y].color
	return false
