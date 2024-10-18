extends Node
class_name MinimaxAgent

signal made_move(from: Vector2, to: Vector2)

const PieceValue = {
	Piece.NAME.Pawn: 1,
	Piece.NAME.Cannon: 3, 
	Piece.NAME.Rook: 5, 
	Piece.NAME.Horse: 3, 
	Piece.NAME.Elephant: 2, 
	Piece.NAME.Advisor: 2, 
	Piece.NAME.King: 100
}

@export var board: Board

var minimax_thread: Thread = Thread.new()

var transposition_table = {}


func state_to_key(state: BoardState):
	return str(state)

func evaluate(state: BoardState):
	# Base in color
	var value = 0
	
	for row in state.map:
		for cell in row:
			if cell is Piece:
				if cell.color == Piece.COLOR.Red:
					value += PieceValue[cell.name]
				elif cell.color == Piece.COLOR.Black:
					value -= PieceValue[cell.name]
	
	return value
	
func minimax(state: BoardState, depth: int, alpha: float, beta: float, is_maximizing: bool):
	var key = state_to_key(state)
	# Check if the state has already been explored
	if key in transposition_table.keys():
		return transposition_table[key]
	
	if state.end_game or depth == 0:
		var eval_value = evaluate(state)
		transposition_table[key] = eval_value
		return eval_value
	
	var moves = board.get_all_valid_move(state)
	if is_maximizing:
		var max_eval = -INF
		for move in moves:
			var new_state = state.duplicate()
			board.move(new_state, move[0], move[1]) # move: [from: Vector2, to: Vector2]
			var eval_value = minimax(new_state, depth - 1, alpha, beta, false)
			max_eval = max(max_eval, eval_value)
			alpha = max(alpha, eval_value)
			if beta <= alpha:
				break
		transposition_table[key] = max_eval
		return max_eval
	
	else:
		var min_eval = INF
		for move in moves:
			var new_state = state.duplicate()
			board.move(new_state, move[0], move[1]) # move: [from: Vector2, to: Vector2]
			var eval_value = minimax(new_state, depth - 1, alpha, beta, false)
			min_eval = min(min_eval, eval_value)
			beta = min(beta, eval_value)
			if beta <= alpha:
				break
		transposition_table[key] = min_eval
		return min_eval

func ai_move(state: BoardState, depth: int):
	var best_move = null
	var best_value = -INF if state.current_turn == Piece.COLOR.Red else INF
	var is_maximizing = state.current_turn == Piece.COLOR.Red
	
	var moves = board.get_all_valid_move(state)
	for move in moves:
		var new_state = state.duplicate()
		board.move(new_state, move[0], move[1])
		var move_value = minimax(new_state, depth - 1, -INF, INF, not is_maximizing)

		# Maximizing for Red, Minimizing for Black
		if state.current_turn == Piece.COLOR.Red:
			if move_value > best_value:
				best_value = move_value
				best_move = move
		else:
			if move_value < best_value:
				best_value = move_value
				best_move = move
	return best_move

func make_move(state: BoardState, depth: int):
	if not minimax_thread.is_started():
		print("Start minimax")
		minimax_thread.start(ai_move.bind(state, depth))

func _process(_delta: float) -> void:
	if minimax_thread.is_started() and not minimax_thread.is_alive():
		var best_move = minimax_thread.wait_to_finish()
		if best_move:
			print("Finish move: ", best_move)
			made_move.emit(best_move[0], best_move[1])

func _exit_tree() -> void:
	if not minimax_thread.is_alive():
		minimax_thread.wait_to_finish()
