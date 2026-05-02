extends Control

@onready var button1 = $"TextureRect/TabContainer/Cosméticos/Sprite2D/Button"
@onready var button2 = $"TextureRect/TabContainer/Cosméticos/Sprite2D2/Button"
@onready var button3 = $"TextureRect/TabContainer/Cosméticos/Sprite2D3/Button"
@onready var button4 = $"TextureRect/TabContainer/Cosméticos/Sprite2D4/Button"

@onready var price_label1 = $"TextureRect/TabContainer/Cosméticos/Sprite2D/Price"
@onready var price_label2 = $"TextureRect/TabContainer/Cosméticos/Sprite2D2/Price"
@onready var price_label3 = $"TextureRect/TabContainer/Cosméticos/Sprite2D3/Price"
@onready var price_label4 = $"TextureRect/TabContainer/Cosméticos/Sprite2D4/Price"

@onready var UserService = preload("res://scripts/services/user_service.gd").new()

var skin_prices: Dictionary = {}
var skin_ids: Dictionary = {}

func _ready() -> void:
	add_child(UserService)
	UserService.load_or_create_user()

	# Identificadores únicos para cada skin
	skin_ids[button1] = "garden"
	skin_ids[button2] = "purple_pink"
	skin_ids[button3] = "natal"
	skin_ids[button4] = "black_manba"

	# Preços convertidos das labels
	skin_prices[button1] = price_label1.text.to_int()
	skin_prices[button2] = price_label2.text.to_int()
	skin_prices[button3] = price_label3.text.to_int()
	skin_prices[button4] = price_label4.text.to_int()

	# Conecta os sinais e atualiza o estado visual do botão
	for btn in [button1, button2, button3, button4]:
		btn.pressed.connect(_on_button_click.bind(btn))
		
		# Se já comprou a skin antes, desativa e muda o texto
		if UserService.has_skin(skin_ids[btn]):
			var lbl = btn.get_node("Label") as Label
			if lbl: lbl.text = "COMPRADO"
			btn.disabled = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/user.tscn")

func _on_button_click(botao_clicado: Button) -> void:
	var current_coins = UserService.get_coins()
	var price = skin_prices[botao_clicado]
	var skin_id = skin_ids[botao_clicado]

	if current_coins >= price:
		UserService.add_coins(-price)
		UserService.buy_skin(skin_id) # Salva a compra no DB
		
		var label_do_botao = botao_clicado.get_node("Label") as Label
		if label_do_botao:
			label_do_botao.text = "COMPRADO"
		
		botao_clicado.disabled = true
		print("Compra salva com sucesso!")
	else:
		print("Saldo insuficiente.")
