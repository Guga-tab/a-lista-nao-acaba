extends Node

signal coins_changed(new_value)

var user_id: int = -1
var avatar_id: int = -1

func _ready():
	load_or_create_user()

func load_or_create_user():
	var users = Database.get_users()

	if users.size() > 0:
		var u = users[0]
		user_id = int(u["id_usuario"])
		avatar_id = int(u["id_avatar"])
		
		# --- COMPATIBILIDADE COM DADOS ANTIGOS ---
		# Garante que as chaves existam caso o usuário seja antigo
		if not u.has("skins_compradas"):
			u["skins_compradas"] = ["default"]
		if not u.has("skin_equipada"):
			u["skin_equipada"] = "default"
			
		# Garante suporte a decorações compradas para usuários antigos
		if not u.has("decoracoes_compradas"):
			u["decoracoes_compradas"] = []
		
		# NOVA CHAVE: Garante que a chave da decoração equipada exista
		if not u.has("decoracao_equipada"):
			u["decoracao_equipada"] = "default"
			
		Database.save_users(users) # Salva as novas chaves estruturais criadas
		return

	# --- CRIAÇÃO DE NOVO USUÁRIO ---
	var user = {
		"id_usuario": 1,
		"id_avatar": 1,
		"coins": 0,
		"estrelas": 0,
		"nome": "User",
		"data_criacao_conta": Time.get_unix_time_from_system(),
		"skins_compradas": ["default"], # Skin inicial gratuita
		"skin_equipada": "default",
		"decoracoes_compradas": [],     # Sem decorações compradas inicialmente
		"decoracao_equipada": "default" # Decoração padrão equipada
	}

	users.append(user)
	Database.save_users(users)

	user_id = 1
	avatar_id = 1

func get_user_ids() -> Dictionary:
	return {"user_id": user_id, "avatar_id": avatar_id}

func add_coins(amount: int):
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			u["coins"] = int(u["coins"]) + amount
			coins_changed.emit(u["coins"])
			break
	Database.save_users(users)

func get_coins() -> int:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return int(u["coins"])
	return 0

# ===============================================
# GESTÃO DE SKINS (COSMÉTICOS)
# ===============================================

func has_skin(skin_id: String) -> bool:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var lista = u.get("skins_compradas", ["default"])
			return skin_id in lista
	return false

func buy_skin(skin_id: String):
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var lista = u.get("skins_compradas", ["default"])
			if not skin_id in lista:
				lista.append(skin_id)
				u["skins_compradas"] = lista
			break
	Database.save_users(users)

func equip_skin(skin_id: String):
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			u["skin_equipada"] = skin_id
			break
	Database.save_users(users)

func get_equipped_skin() -> String:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return u.get("skin_equipada", "default")
	return "default"

func unequip_skin():
	equip_skin("default")

# ===============================================
# GESTÃO DE DECORAÇÕES
# ===============================================

func has_decoration(deco_id: String) -> bool:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var lista = u.get("decoracoes_compradas", [])
			return deco_id in lista
	return false

func buy_decoration(deco_id: String):
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var lista = u.get("decoracoes_compradas", [])
			if not deco_id in lista:
				lista.append(deco_id)
				u["decoracoes_compradas"] = lista
			break
	Database.save_users(users)

# ===============================================
# GESTÃO DE EQUIPAR DECORAÇÕES
# ===============================================

# Equipa uma decoração
func equip_decoration(deco_id: String):
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			u["decoracao_equipada"] = deco_id
			break
	Database.save_users(users)

# Retorna qual decoração está equipada atualmente
func get_equipped_decoration() -> String:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			# Se não tiver nada equipado, retorna vazio "" ou "none", evitando que "default" seja confundido
			return u.get("decoracao_equipada", "")
	return ""

# Volta para nenhuma decoração (ou padrão)
func unequip_decoration():
	equip_decoration("")

# ===============================================
# RESET DE DADOS PARA TESTES
# ===============================================
func reset_user_data() -> void:
	print("Resetando dados do usuário para teste...")
	var empty_users: Array = []
	Database.save_users(empty_users)
	user_id = -1
	avatar_id = -1
	load_or_create_user()
	coins_changed.emit(0)
	print("Dados resetados com sucesso!")
