extends BaseUI


const save_path = "user://options_data.tres"

@export var piece_set_holder: PieceSetHolder
@export var characters_collection_holder: CharacterCollectionHolder
@export var board_set_holder: Resource # TODO: refill this value

var options_data: OptionsData
var music_bus_id = AudioServer.get_bus_index("Music")
var sfx_bus_id = AudioServer.get_bus_index("SFX")

@onready var board_preview: TextureRect = %BoardPreview
@onready var piece_preview: TextureRect = %PiecePreview
@onready var char_preview: TextureRect = %CharPreview

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_data()
	handle_data_change()

func load_data():
	if ResourceLoader.exists(save_path):
		options_data = ResourceLoader.load(save_path)
	else:
		options_data = OptionsData.new()
		save_data()

func save_data():
	ResourceSaver.save(options_data, save_path)

func handle_data_change():
	piece_preview.texture = piece_set_holder.get_set(options_data.piece_set_idx).preview_texture
	char_preview.texture = characters_collection_holder.get_collection(options_data.character_set_idx).preview_texture
	#board_preview.texture = board_set_holder.get_collection(options_data.board_set_idx).preview_texture
	
	SignalBus.board_settings_updated.emit(options_data.piece_set_idx, options_data.character_set_idx)

#region Board Appearance Settings

func _on_board_arrow_pressed(amount: int):
	pass
	
func _on_character_arrow_pressed(amount: int):
	var cur = options_data.character_set_idx
	cur = (cur + amount + characters_collection_holder.get_length()) % characters_collection_holder.get_length()
	options_data.character_set_idx = cur
	handle_data_change()

func _on_piece_arrow_pressed(amount: int):
	var cur = options_data.piece_set_idx
	cur = (cur + amount + piece_set_holder.get_length()) % piece_set_holder.get_length()
	options_data.piece_set_idx = cur
	handle_data_change()

func _on_music_slider_change(value: float):
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_id, value < 0.05)

func _on_sfx_slider_change(value: float):
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_id, value < 0.05)
#endregion
