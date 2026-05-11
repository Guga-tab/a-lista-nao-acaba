extends Control
@onready var option_button = $OptionButton

func _ready() -> void:
	option_button.modulate.a = 1.0
	
func _on_exit_button_pressed() -> void:
	queue_free()

#func _reset_texture_rects(node):
	#for child in node.get_children():
		#if child is TextureRect:
			#child.custom_minimum_size = Vector2(0, 0)
		#_reset_texture_rects(child)

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		print("CheckButton ativado! Apagando dados do jogo...")
		UserService.reset_user_data()
		get_tree().change_scene_to_file("res://scenes/screens/title.tscn")
