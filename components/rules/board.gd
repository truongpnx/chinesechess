extends Node
class_name Board

const MAX_WIDTH :int = 8
const MAX_HEIGHT :int = 9

# red on top, black under
const RED_REGION: Array[int] = [0, 4]
const BLACK_REGION: Array[int] = [5, 9]

const PIECE_POSITON = {
	Piece.NAME.Pawn: [
		[3, 0],
		[3, 2],
		[3, 4],
		[3, 6],
		[3, 8]
	],
	Piece.NAME.Cannon: [
		[2, 1],
		[2, 7]
	],
	Piece.NAME.Rook: [
		[0, 0],
		[0, 8]
	],
	Piece.NAME.Horse: [
		[0, 1],
		[0, 7]
	],
	Piece.NAME.Elephant: [
		[0, 2],
		[0, 6]
	],
	Piece.NAME.Advisor: [
		[0, 3],
		[0, 5]
	],
	Piece.NAME.King: [
		[0, 4]
	],
}


var state: BoardState

var pawn_rule: PawnRule
var cannon_rule: CannonRule
var rook_rule: RookRule
var horse_rule: HorseRule
var elephent_rule: ElephantRule
var advisor_rule: AdvisorRule
var king_rule: KingRule

var piece_list = {}

func _ready() -> void:
	# create rules
	pawn_rule = PawnRule.new()
	cannon_rule = CannonRule.new()
	rook_rule = RookRule.new()
	horse_rule = HorseRule.new()
	elephent_rule = ElephantRule.new()
	advisor_rule = AdvisorRule.new()
	king_rule = KingRule.new()
	
	for key in Piece.NAME.values():
		piece_list[key] = [Piece.new(Piece.COLOR.Red, key), Piece.new(Piece.COLOR.Black, key)]

	# create map
	reset()


func reset():
	state = BoardState.new()

	for key in PIECE_POSITON.keys():
		for pos in PIECE_POSITON.get(key):
			var red_piece = piece_list[key][0]
			state.map[pos[0]][pos[1]] = red_piece

			var black_piece = piece_list[key][1]
			state.map[MAX_HEIGHT - pos[0]][pos[1]] = black_piece
	

## Return a array of [from: Vector2, to: Vector2] of all posible move at current turn
func get_all_valid_move(_state: BoardState) -> Array:
	var movable = []
	for i in range(MAX_HEIGHT + 1):
		for j in range(MAX_WIDTH + 1):
			var piece = _state.map[i][j]
			if piece is Piece and piece.color == state.current_turn:
				var pos = Vector2(i, j)
				var move_pairs = get_piece_valid_move(_state, Vector2(i, j)).map(func(e): return [pos, e])
				movable.append_array(move_pairs)

	return movable

func get_piece_valid_move(_state: BoardState, pos: Vector2) -> Array[Vector2]:
	var movable: Array[Vector2] = []
	var piece = _state.map[pos.x][pos.y]
	if not piece:
		return movable
	
	match piece.name:
		Piece.NAME.Pawn:
			movable = pawn_rule.get_movable_pos(_state.map, piece, pos)
		Piece.NAME.Cannon:
			movable = cannon_rule.get_movable_pos(_state.map, piece, pos)
		Piece.NAME.Rook:
			movable = rook_rule.get_movable_pos(_state.map, piece, pos)
		Piece.NAME.Horse:
			movable = horse_rule.get_movable_pos(_state.map, piece, pos)
		Piece.NAME.Elephant:
			movable = elephent_rule.get_movable_pos(_state.map, piece, pos)
		Piece.NAME.Advisor:
			movable = advisor_rule.get_movable_pos(_state.map, piece, pos)
		Piece.NAME.King:
			movable = king_rule.get_movable_pos(_state.map, piece, pos)
	return movable

func is_valid_move(_state: BoardState, start_pos: Vector2, target_pos: Vector2) -> bool:
	if _state.end_game:
		return false
	
	var movable = get_piece_valid_move(_state, start_pos)
	#print("Valid move:" + str(movable))
	#print("Start: " + str(start_pos))
	#print("Target: " + str(target_pos))
	return target_pos in movable

## Move base on board state
func move(_state: BoardState, start_pos: Vector2, target_pos: Vector2):

	var piece = _state.map[start_pos[0]][start_pos[1]]
	_state.map[target_pos[0]][target_pos[1]] = piece
	_state.map[start_pos[0]][start_pos[1]] = null
	
	_state.current_turn = Piece.COLOR.Black if _state.current_turn == Piece.COLOR.Red else Piece.COLOR.Red
	_state.end_game = is_king_captured(_state)
	
func is_king_captured(_state: BoardState):
	for row in _state.map:
		for piece in row:
			if piece and piece.name == Piece.NAME.King and piece.color == _state.current_turn:
				return false
	return true
