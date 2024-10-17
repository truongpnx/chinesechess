extends Resource
class_name CharacterCollection

@export var set_one: Array[CharacterData] = [
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
]

@export var set_two: Array[CharacterData] = [
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
	CharacterData.new(),
]

@export var preview_texture: Texture2D

func get_data_of_piece_name(set_idx: int, name: Piece.NAME) -> CharacterData:
	'''
		"set_idx" value should be 0 or 1
		Return "CharacterData" of piece's name in that set
	'''
	
	var character_set = set_one if set_idx == 0 else set_two
	for c in character_set:
		if c.name == name:
			return c
	return null
