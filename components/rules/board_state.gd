extends RefCounted
class_name BoardState

var map: Array[Array] = []
var current_turn: Piece.COLOR = Piece.COLOR.Red
var end_game: bool
	
func _init() -> void:
	end_game = false
	current_turn = Piece.COLOR.Red
	map.resize(Board.MAX_HEIGHT + 1)
	for row in map:
		row.resize(Board.MAX_WIDTH + 1)
		row.fill(null)


## Return a clone BoardState
func duplicate():
	var state = BoardState.new()
	state.map = map.duplicate(true)
	state.current_turn = current_turn
	state.end_game = end_game
	return state

func _to_string() -> String:
	var res = ""
	res += "Turn " + str(current_turn) + '\n'
	for row in map:
		var str_row = ','.join(row.map(func(e): return str(e)))
		res += '[' + str_row + ']\n'
	res += "End " + str(end_game)
	return res
