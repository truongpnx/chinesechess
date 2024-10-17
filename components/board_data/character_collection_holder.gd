extends Resource
class_name CharacterCollectionHolder

@export var collection_list: Array[CharacterCollection] = []

func get_collection(index: int) -> CharacterCollection:
	assert(index < len(collection_list), "Missing Character Collection at %d" % index)
	
	return collection_list[index]

func get_length():
	return len(collection_list)
