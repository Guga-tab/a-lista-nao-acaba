extends Control

@onready var button1 = $"TextureRect/TabContainer/Cosméticos/Sprite2D/Button"
@onready var button2 = $"TextureRect/TabContainer/Cosméticos/Sprite2D2/Button"
@onready var button3 = $"TextureRect/TabContainer/Cosméticos/Sprite2D3/Button"
@onready var button4 = $"TextureRect/TabContainer/Cosméticos/Sprite2D4/Button"

@onready var UserService = preload("res://scripts/services/user_service.gd").new()
var skin_ids: Dictionary = {}

func _ready() -> void:
	add_child(UserService)
	UserService.load_or_create_user()

	skin_ids[button1] = "garden"
	skin_ids[button2] = "purple_pink"
	skin_ids[button3] = "natal"
	skin_ids[button4] = "black_manba"

	for btn in [button1, button2, button3, button4]:
		btn.pressed.connect(_on_equip_click.bind(btn))
	
	update_inventory_ui()

func update_inventory_ui():
	var equipped = UserService.get_equipped_skin()
	
	for btn in skin_ids.keys():
		var skin_id = skin_ids[btn]
		var lbl = btn.get_node("Label") as Label
		
		# Se ele possui a skin
		if UserService.has_skin(skin_id):
			if skin_id == equipped:
				if lbl: lbl.text = "EQUIPADO"
				btn.modulate = Color(0.5, 1, 0.5) # Deixa verde/destacado
			else:
				if lbl: lbl.text = "EQUIPAR"
				btn.modulate = Color(1, 1, 1)
			btn.disabled = false
		else:
			if lbl: lbl.text = "BLOQUEADO"
			btn.disabled = true

func _on_equip_click(botao_clicado: Button) -> void:
	var skin_id = skin_ids[botao_clicado]
	var current_equipped = UserService.get_equipped_skin()
	
	# Se clicar em uma que já está equipada, ela desequipa voltando para a padrão
	if skin_id == current_equipped:
		UserService.unequip_skin()
	else:
		UserService.equip_skin(skin_id)
		
	update_inventory_ui()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/user.tscn")
