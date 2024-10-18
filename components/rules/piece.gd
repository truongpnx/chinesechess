class_name Piece
extends RefCounted

enum COLOR {Red, Black}
enum NAME {Pawn, Cannon, Rook, Horse, Elephant, Advisor, King}

var color: COLOR
var name: NAME

func _init(_color: COLOR, _name: NAME) -> void:
	self.color = _color
	self.name = _name

func _to_string() -> String:
	return "[%s, %s]" % [color, name]
