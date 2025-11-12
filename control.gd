extends Control

func _ready():
	# conecta os sinais manualmente
	$botao_jogar.pressed.connect(_on_botao_jogar_pressed)
	$botao_sair.pressed.connect(_on_botao_sair_pressed)

func _on_botao_jogar_pressed():
	print("Botão JOGAR clicado!")
	get_tree().change_scene_to_file("res://principal.tscn")

func _on_botao_sair_pressed():
	print("Botão SAIR clicado!")
	get_tree().quit()
