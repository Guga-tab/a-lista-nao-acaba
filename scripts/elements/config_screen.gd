extends Control
# Precarrega o UserService para usar a função de reset
@onready var UserService = preload("res://scripts/services/user_service.gd").new()
@onready var option_button = $OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	option_button.modulate.a = 1.0
	 # Adiciona o UserService como filho deste nó para ele funcionar corretamente
	add_child(UserService)
	
func _on_exit_button_pressed() -> void:
	queue_free()

func _reset_texture_rects(node):
	for child in node.get_children():
		if child is TextureRect:
			child.custom_minimum_size = Vector2(0, 0)
		_reset_texture_rects(child)

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		print("CheckButton ativado! Apagando dados do jogo...")

		# 1. Executa a função de reset do serviço
		UserService.reset_user_data()

		## 2. Desmarca o botão novamente para ele não ficar ativo
		#button_pressed = false

		# 3. Recarrega a cena atual para aplicar todas as mudanças na interface
		get_tree().change_scene_to_file("res://scenes/screens/title.tscn")
