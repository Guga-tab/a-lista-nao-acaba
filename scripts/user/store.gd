extends Control

# ========================
# Decorações
# ========================
@onready var Dbutton1 = $"TextureRect/TabContainer/Decoration/Dec/Button"
@onready var Dbutton2 = $"TextureRect/TabContainer/Decoration/Dec2/Button"
@onready var Dbutton3 = $"TextureRect/TabContainer/Decoration/Dec3/Button"
@onready var Dbutton4 = $"TextureRect/TabContainer/Decoration/Dec4/Button"

@onready var Dprice_label1 = $"TextureRect/TabContainer/Decoration/Dec/Price"
@onready var Dprice_label2 = $"TextureRect/TabContainer/Decoration/Dec2/Price"
@onready var Dprice_label3 = $"TextureRect/TabContainer/Decoration/Dec3/Price"
@onready var Dprice_label4 = $"TextureRect/TabContainer/Decoration/Dec4/Price"

# ========================
# Cosméticos
# ========================
@onready var Cbutton1 = $"TextureRect/TabContainer/Costumes/Cos/Button"
@onready var Cbutton2 = $"TextureRect/TabContainer/Costumes/Cos2/Button"
@onready var Cbutton3 = $"TextureRect/TabContainer/Costumes/Cos3/Button"
@onready var Cbutton4 = $"TextureRect/TabContainer/Costumes/Cos4/Button"

@onready var Cprice_label1 = $"TextureRect/TabContainer/Costumes/Cos/Price"
@onready var Cprice_label2 = $"TextureRect/TabContainer/Costumes/Cos2/Price"
@onready var Cprice_label3 = $"TextureRect/TabContainer/Costumes/Cos3/Price"
@onready var Cprice_label4 = $"TextureRect/TabContainer/Costumes/Cos4/Price"

@onready var UserService = preload("res://scripts/services/user_service.gd").new()

var cosmetic_ids: Dictionary = {}
var deco_ids: Dictionary = {}
var item_prices: Dictionary = {}

func _ready() -> void:
	add_child(UserService)
	UserService.load_or_create_user()

	# 1. Registro de Cosméticos
	cosmetic_ids[Cbutton1] = "garden"
	cosmetic_ids[Cbutton2] = "purple_pink"
	cosmetic_ids[Cbutton3] = "natal"
	cosmetic_ids[Cbutton4] = "black_manba"

	item_prices[Cbutton1] = Cprice_label1.text.to_int() if Cprice_label1 else 0
	item_prices[Cbutton2] = Cprice_label2.text.to_int() if Cprice_label2 else 0
	item_prices[Cbutton3] = Cprice_label3.text.to_int() if Cprice_label3 else 0
	item_prices[Cbutton4] = Cprice_label4.text.to_int() if Cprice_label4 else 0

	# 2. Registro de Decorações
	deco_ids[Dbutton1] = "bedroom"
	deco_ids[Dbutton2] = "living_room"
	deco_ids[Dbutton3] = "toilet"
	deco_ids[Dbutton4] = "kitchen"

	item_prices[Dbutton1] = Dprice_label1.text.to_int() if Dprice_label1 else 0
	item_prices[Dbutton2] = Dprice_label2.text.to_int() if Dprice_label2 else 0
	item_prices[Dbutton3] = Dprice_label3.text.to_int() if Dprice_label3 else 0
	item_prices[Dbutton4] = Dprice_label4.text.to_int() if Dprice_label4 else 0

	# Conecta os sinais
	for btn in cosmetic_ids.keys() + deco_ids.keys():
		if btn == null: 
			push_error("Atenção: Um dos botões da Store não foi encontrado na árvore da cena!")
			continue
		btn.pressed.connect(_on_button_click.bind(btn))

	# Atualiza o estado visual inicial de todos os botões
	update_store_ui()


func update_store_ui() -> void:
	var current_coins = UserService.get_coins()
	
	for btn in cosmetic_ids.keys() + deco_ids.keys():
		if btn == null: continue
		
		var lbl = btn.get_node_or_null("Label") as Label
		var price = item_prices.get(btn, 0)
		var ja_comprou = false
		
		if btn in deco_ids:
			ja_comprou = UserService.has_decoration(deco_ids[btn])
		else:
			ja_comprou = UserService.has_skin(cosmetic_ids[btn])
			
		if ja_comprou:
			if lbl: lbl.text = "COMPRADO"
			btn.disabled = true
			btn.modulate = Color(0.5, 1, 0.5) # Verde
		else:
			# SE O JOGADOR TEM DINHEIRO: O botão fica ativo
			if current_coins >= price:
				btn.disabled = false
				btn.modulate = Color(1, 1, 1) # Cor normal
			else:
				# SE NÃO TEM DINHEIRO: O botão fica bloqueado (desabilitado)
				btn.disabled = true
				btn.modulate = Color(0.4, 0.4, 0.4) # Cinza escuro


func _on_button_click(botao_clicado: Button) -> void:
	var current_coins = UserService.get_coins()
	var price = item_prices.get(botao_clicado, 0)

	if current_coins >= price:
		UserService.add_coins(-price)
		
		if botao_clicado in deco_ids:
			var deco_id = deco_ids[botao_clicado]
			UserService.buy_decoration(deco_id)
			print("Decoração comprada: ", deco_id)
		else:
			var skin_id = cosmetic_ids[botao_clicado]
			UserService.buy_skin(skin_id)
			print("Skin comprada: ", skin_id)
			
		# Atualiza a interface da loja inteira (bloqueia o que comprou, reavalia o saldo dos outros)
		update_store_ui()
	else:
		print("Saldo insuficiente para esta compra.")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/user.tscn")
