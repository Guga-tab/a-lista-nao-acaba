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
		"star_balance": 0,
		"streak_count": 0,
		"last_streak_date": "",
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
# GESTÃO DE MÚLTIPLAS DECORAÇÕES EQUIPADAS
# ===============================================

# Retorna se a decoração específica está equipada
func is_decoration_equipped(deco_id: String) -> bool:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var equipadas = u.get("decoracoes_equipadas", [])
			if typeof(equipadas) == TYPE_ARRAY:
				return deco_id in equipadas
	return false

# Adiciona uma decoração à lista de equipadas
func equip_decoration(deco_id: String):
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var equipadas = u.get("decoracoes_equipadas", [])
			if typeof(equipadas) != TYPE_ARRAY:
				equipadas = []
			if not deco_id in equipadas:
				equipadas.append(deco_id)
				u["decoracoes_equipadas"] = equipadas
			break
	Database.save_users(users)

# Remove uma decoração da lista de equipadas
func unequip_decoration(deco_id: String):
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var equipadas = u.get("decoracoes_equipadas", [])
			if typeof(equipadas) == TYPE_ARRAY:
				if deco_id in equipadas:
					equipadas.erase(deco_id)
					u["decoracoes_equipadas"] = equipadas
			break
	Database.save_users(users)

# Retorna a lista completa de decorações equipadas
func get_equipped_decorations() -> Array:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var equipadas = u.get("decoracoes_equipadas", [])
			if typeof(equipadas) == TYPE_ARRAY:
				return equipadas
	return []
	
# ===============================================
# OFENSIVA
# ===============================================

# Retorna os dados de ofensiva
func get_streak_data() -> Dictionary:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return {
				"count": u.get("streak_count", 0),
				"last_date": u.get("last_streak_date", "") # Formato "YYYY-MM-DD"
			}
	return {"count": 0, "last_date": ""}

# Verifica e atualiza a ofensiva
# No UserService.gd

# --- LÓGICA DE GANHO (Chamar ao completar a Task na scene Mission) ---
func update_streak():
	var users = Database.get_users()
	var today = Time.get_date_string_from_system()
	var yesterday = Time.get_date_string_from_unix_time(Time.get_unix_time_from_system() - 86400)
	
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var last_date = u.get("last_streak_date", "")
			if last_date == today: return # Já computou hoje
			
			# Incrementa a ofensiva
			if last_date == yesterday:
				u["streak_count"] = int(u.get("streak_count", 0)) + 1
			else:
				u["streak_count"] = 1 # Começa ou recomeça ofensiva
			
			# NOVA REGRA: A cada 3 dias de ofensiva, ganha 5 estrelas
			if int(u["streak_count"]) % 3 == 0:
				var current_stars = int(u.get("stars_balance", 0))
				u["stars_balance"] = current_stars
				print("Parabéns! +5 estrelas por 3 dias de ofensiva!")
				
			u["last_streak_date"] = today
			break
	Database.save_users(users)

# --- LÓGICA DE PERDA (Chamar no _ready da Home ou Splash para checar ausência) ---
func check_streak_expiry():
	var users = Database.get_users()
	var today = Time.get_date_string_from_system()
	var yesterday = Time.get_date_string_from_unix_time(Time.get_unix_time_from_system() - 86400)
	
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var last_date = u.get("last_streak_date", "")
			
			# Se o usuário não jogou hoje nem ontem, ele está ausente
			if last_date != "" and last_date != today and last_date != yesterday:
				# 1. Ofensiva volta para 0
				u["streak_count"] = 0 
				
				# 2. NOVA REGRA: Perde apenas 1 estrela de "multa"
				var current_stars = int(u.get("stars_balance", 0))
				if current_stars > 0:
					u["stars_balance"] = current_stars - 1
					print("Aviso: -1 estrela por ausência.")
				
				# Atualiza a data para "ontem" para não cobrar várias vezes no mesmo dia
				# se ele abrir e fechar o jogo
				u["last_streak_date"] = yesterday 
				
				Database.save_users(users)
			break
			
# Retorna o saldo real de estrelas para a loja
func get_stars_balance() -> int:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return int(u.get("stars_balance", 0))
	return 0
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
