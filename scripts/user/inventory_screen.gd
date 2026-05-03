extends Control

# ========================
# Decorações
# ========================
@onready var Dbutton1 = $"TextureRect/TabContainer/Decoration/Dec/Button"
@onready var Dbutton2 = $"TextureRect/TabContainer/Decoration/Dec2/Button"
@onready var Dbutton3 = $"TextureRect/TabContainer/Decoration/Dec3/Button"
@onready var Dbutton4 = $"TextureRect/TabContainer/Decoration/Dec4/Button"

# ========================
# Cosméticos
# ========================
@onready var Cbutton1 = $"TextureRect/TabContainer/Costumes/Cos/Button"
@onready var Cbutton2 = $"TextureRect/TabContainer/Costumes/Cos2/Button"
@onready var Cbutton3 = $"TextureRect/TabContainer/Costumes/Cos3/Button"
@onready var Cbutton4 = $"TextureRect/TabContainer/Costumes/Cos4/Button"

@onready var UserService = preload("res://scripts/services/user_service.gd").new()

var cosmetic_ids: Dictionary = {}
var deco_ids: Dictionary = {}

func _ready() -> void:
	add_child(UserService)
	UserService.load_or_create_user()

	# 1. Registro de Cosméticos
	cosmetic_ids[Cbutton1] = "garden"
	cosmetic_ids[Cbutton2] = "purple_pink"
	cosmetic_ids[Cbutton3] = "natal"
	cosmetic_ids[Cbutton4] = "black_manba"

	# 2. Registro de Decorações
	deco_ids[Dbutton1] = "bedroom"
	deco_ids[Dbutton2] = "living_room"
	deco_ids[Dbutton3] = "toilet"
	deco_ids[Dbutton4] = "kitchen"

	# Conecta os sinais de clique nos botões válidos
	for btn in cosmetic_ids.keys() + deco_ids.keys():
		if btn == null: 
			continue
		btn.pressed.connect(_on_equip_click.bind(btn))
	
	# Atualiza o inventário visualmente
	update_inventory_ui()


func update_inventory_ui() -> void:
	var equipped_skin = UserService.get_equipped_skin()
	var equipped_deco = UserService.get_equipped_decoration()
	
	for btn in cosmetic_ids.keys() + deco_ids.keys():
		if btn == null: continue
			
		var lbl = btn.get_node_or_null("Label") as Label
		var has_item = false
		var is_equipped = false
		
		# Verifica se o jogador possui o item e se está equipado
		if btn in deco_ids:
			var deco_id = deco_ids[btn]
			has_item = UserService.has_decoration(deco_id)
			is_equipped = (deco_id == equipped_deco)
		else:
			var skin_id = cosmetic_ids[btn]
			has_item = UserService.has_skin(skin_id)
			is_equipped = (skin_id == equipped_skin)

		# Aplica as regras visuais
		if has_item:
			# Se JÁ COMPROU: botão liberado
			btn.disabled = false
			if is_equipped:
				if lbl: lbl.text = "EQUIPADO"
				btn.modulate = Color(0.5, 1.0, 0.5) # Tom verde (equipado)
			else:
				if lbl: lbl.text = "EQUIPAR"
				btn.modulate = Color(1, 1, 1) # Tom normal (disponível para equipar)
		else:
			# Se NÃO COMPROU: botão bloqueado
			if lbl: lbl.text = "BLOQUEADO"
			btn.disabled = true
			btn.modulate = Color(0.3, 0.3, 0.3) # Tom cinza escuro (bloqueado)


func _on_equip_click(botao_clicado: Button) -> void:
	if botao_clicado.disabled:
		return

	if botao_clicado in deco_ids:
		var deco_id = deco_ids[botao_clicado]
		var current_equipped_deco = UserService.get_equipped_decoration()
		
		# Se já está equipado, desequipa. Se não, equipa.
		if deco_id == current_equipped_deco:
			UserService.unequip_decoration()
		else:
			UserService.equip_decoration(deco_id)
	else:
		var skin_id = cosmetic_ids[botao_clicado]
		var current_equipped_skin = UserService.get_equipped_skin()
		
		if skin_id == current_equipped_skin:
			UserService.unequip_skin()
		else:
			UserService.equip_skin(skin_id)
			
	# Atualiza a interface do inventário imediatamente para refletir as mudanças
	update_inventory_ui()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/user.tscn")
