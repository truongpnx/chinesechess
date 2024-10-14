extends TextureButton
class_name MarkerButton

signal data_transfered(map_pos: Vector2)

func _ready() -> void:
	pressed.connect(_transfer_data)
	
func _transfer_data():
	data_transfered.emit(get_meta("map_pos"))
	
func add_data(data: Vector2):
	set_meta("map_pos", data)
