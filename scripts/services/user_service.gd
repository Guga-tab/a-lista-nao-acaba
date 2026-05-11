extends Node

signal coins_changed(new_value)
signal skin_changed(new_skin_name)

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
		
		if not u.has("skins_compradas"):
			u["skins_compradas"] = ["default"]
		if not u.has("skin_equipada"):
			u["skin_equipada"] = "default"
			
		if not u.has("decoracoes_compradas"):
			u["decoracoes_compradas"] = []
		
		if not u.has("decoracao_equipada"):
			u["decoracao_equipada"] = "default"
			
		Database.save_users(users)
		return

	# New user
	var user = {
		"id_usuario": 1,
		"id_avatar": 1,
		"coins": 0,
		"stars_balance": 0,
		"streak_count": 0,
		"last_streak_date": "",
		"nome": "User",
		"data_criacao_conta": Time.get_unix_time_from_system(),
		"skins_compradas": ["default"],
		"skin_equipada": "default",
		"decoracoes_compradas": [],
		"decoracao_equipada": "default"
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


# Star
func get_stars_balance() -> int:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return int(u.get("stars_balance", 0))
	return 0

func spend_stars(amount: int) -> bool:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var balance = int(u.get("stars_balance", 0))
			if balance >= amount:
				u["stars_balance"] = balance - amount 
				Database.save_users(users)
				return true
	return false

# Skin
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
	
	skin_changed.emit(skin_id)
	
func get_equipped_skin() -> String:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return u.get("skin_equipada", "default")
	return "default"

func unequip_skin():
	equip_skin("default")

# Decoration
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

func is_decoration_equipped(deco_id: String) -> bool:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var equipadas = u.get("decoracoes_equipadas", [])
			if typeof(equipadas) == TYPE_ARRAY:
				return deco_id in equipadas
	return false

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

func get_equipped_decorations() -> Array:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var equipadas = u.get("decoracoes_equipadas", [])
			if typeof(equipadas) == TYPE_ARRAY:
				return equipadas
	return []
	
# Offensive
func get_streak_data() -> Dictionary:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return {
				"count": u.get("streak_count", 0),
				"last_date": u.get("last_streak_date", "") # Format "YYYY-MM-DD"
			}
	return {"count": 0, "last_date": ""}

func update_streak():
	var users = Database.get_users()
	var today = Time.get_date_string_from_system()
	
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var last_date = u.get("last_streak_date", "")
			
			if last_date == today:
				print("Ofensiva já atualizada hoje. Aguarde até amanhã!")
				return
			
			var current_streak = int(u.get("streak_count", 0)) + 1
			u["streak_count"] = current_streak
			u["last_streak_date"] = today
			
			print("Ofensiva atualizada: ", current_streak)
			
			if current_streak % 3 == 0:
				var current_stars = int(u.get("stars_balance", 0))
				u["stars_balance"] = current_stars + 5
				print("Parabéns! 3 dias de foco: +5 Estrelas. Total: ", u["stars_balance"])
			
			Database.save_users(users)
			break

func check_streak_expiry():
	var users = Database.get_users()
	var today = Time.get_date_string_from_system()
	var yesterday = Time.get_date_string_from_unix_time(Time.get_unix_time_from_system() - 86400)
	
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var last_date = u.get("last_streak_date", "")
			
			if last_date != "" and last_date != today and last_date != yesterday:
				u["streak_count"] = 0 
				
				var current_stars = int(u.get("stars_balance", 0))
				if current_stars > 0:
					u["stars_balance"] = current_stars - 1
					print("Aviso: -1 estrela por ausência.")
				
				u["last_streak_date"] = yesterday 
				
				Database.save_users(users)
			break

# Reset Data
func reset_user_data() -> void:
	print("Resetando dados do usuário para teste...")
	var empty_users: Array = []
	Database.save_users(empty_users)
	user_id = -1
	avatar_id = -1
	load_or_create_user()
	coins_changed.emit(0)
	print("Dados resetados com sucesso!")
