extends Resource
class_name PieceSetHolder

@export var list: Array[PieceSetData] = []

func get_set(index: int) -> PieceSetData:
	assert(index < len(list), "Missing Character Collection at %d" % index)
	
	return list[index]


func get_length():
	return len(list)
