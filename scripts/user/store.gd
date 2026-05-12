extends Control

# Interfaces
@onready var Dbuttons = [
	$"TextureRect/TabContainer/Decoration/Dec/Button",
	$"TextureRect/TabContainer/Decoration/Dec2/Button",
	$"TextureRect/TabContainer/Decoration/Dec3/Button",
	$"TextureRect/TabContainer/Decoration/Dec4/Button"
]

@onready var Cbuttons = [
	$"TextureRect/TabContainer/Costumes/Cos/Button",
	$"TextureRect/TabContainer/Costumes/Cos2/Button",
	$"TextureRect/TabContainer/Costumes/Cos3/Button",
	$"TextureRect/TabContainer/Costumes/Cos4/Button"
]

var item_ids: Dictionary = {}
var item_prices: Dictionary = {}
var item_currencies: Dictionary = {}

func _ready() -> void:
	UserService.load_or_create_user()

	_registrar_item(Cbuttons[0], "garden", "COINS")
	_registrar_item(Cbuttons[1], "purple_pink", "COINS")
	_registrar_item(Cbuttons[2], "natal", "COINS") 
	_registrar_item(Cbuttons[3], "black_manba", "COINS")

	_registrar_item(Dbuttons[0], "bedroom", "COINS")
	_registrar_item(Dbuttons[1], "living_room", "COINS")
	_registrar_item(Dbuttons[2], "toilet", "STARS")
	_registrar_item(Dbuttons[3], "kitchen", "STARS")

	for btn in item_ids.keys():
		if btn:
			btn.pressed.connect(_on_button_click.bind(btn))

	update_store_ui()

func _registrar_item(btn: Button, id: String, currency: String):
	if btn == null: return
	
	item_ids[btn] = id
	item_currencies[btn] = currency
	
	var price_label = btn.get_parent().get_node_or_null("Price") as Label
	item_prices[btn] = price_label.text.to_int() if price_label else 0

func update_store_ui() -> void:
	var coins = UserService.get_coins()
	var stars = UserService.get_stars_balance()
	
	for btn in item_ids.keys():
		var id = item_ids[btn]
		var price = item_prices[btn]
		var currency = item_currencies[btn]
		var lbl = btn.get_node_or_null("Label") as Label
		
		var ja_possui = UserService.has_decoration(id) if btn in Dbuttons else UserService.has_skin(id)
		
		if ja_possui:
			if lbl: lbl.text = "COMPRADO"
			btn.disabled = true
			btn.modulate = Color(0.5, 1, 0.5) # Verde
		else: 
			var tem_saldo = (coins >= price) if currency == "COINS" else (stars >= price)
			
			btn.disabled = !tem_saldo
			
			if not tem_saldo:
				btn.modulate = Color(0.4, 0.4, 0.4)
			elif currency == "STARS":
				btn.modulate = Color(1, 0.8, 0.2)
			else:
				btn.modulate = Color(1, 1, 1)

func _on_button_click(btn: Button) -> void:
	var id = item_ids[btn]
	var price = item_prices[btn]
	var currency = item_currencies[btn]
	var sucesso = false

	if currency == "COINS":
		if UserService.get_coins() >= price:
			UserService.add_coins(-price)
			sucesso = true
	else: # STARS
		if UserService.get_stars_balance() >= price:
			sucesso = UserService.spend_stars(price) 

	if sucesso:
		if btn in Dbuttons:
			UserService.buy_decoration(id)
		else:
			UserService.buy_skin(id)
		
		print("Compra realizada com sucesso: ", id, " usando ", currency)
		update_store_ui()
	else:
		print("Erro: Saldo insuficiente em ", currency)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/user.tscn")
