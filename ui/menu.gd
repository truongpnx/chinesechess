extends BaseUI

func on_one_player_pressed():
	pass
	
func on_two_player_pressed():
	parent.go_to(GameManager.UI_TYPE.Menu, GameManager.UI_TYPE.Chessboard)

func on_options_pressed():
	parent.go_to(GameManager.UI_TYPE.Menu, GameManager.UI_TYPE.Options)

func on_about_pressed():
	pass
