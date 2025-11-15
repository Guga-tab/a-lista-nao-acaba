extends Control

# ========================
# Botões da tela inicial
# ========================
@onready var botao_jogar = $botao_jogar
@onready var botao_sair = $botao_sair

func _ready():
	# Conectar sinais apenas se ainda não estiverem conectados
	var jogar_callable = Callable(self, "_on_botao_jogar_pressed")
	if not botao_jogar.pressed.is_connected(jogar_callable):
		botao_jogar.pressed.connect(jogar_callable)
	
	var sair_callable = Callable(self, "_on_botao_sair_pressed")
	if not botao_sair.pressed.is_connected(sair_callable):
		botao_sair.pressed.connect(sair_callable)

# ========================
# Funções dos botões
# ========================
func _on_botao_jogar_pressed():
	print("Botão JOGAR clicado!")
	get_tree().change_scene_to_file("res://principal.tscn")

func _on_botao_sair_pressed():
	print("Botão SAIR clicado!")
	get_tree().quit()
