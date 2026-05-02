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
		
		# Garante que as chaves de skins existam caso o usuário seja antigo
		if not u.has("skins_compradas"):
			u["skins_compradas"] = ["default"]
		if not u.has("skin_equipada"):
			u["skin_equipada"] = "default"
		return

	# Criação de novo usuário com suporte a skins
	var user = {
		"id_usuario": 1,
		"id_avatar": 1,
		"coins": 0,
		"estrelas": 0,
		"nome": "User",
		"data_criacao_conta": Time.get_unix_time_from_system(),
		"skins_compradas": ["default"], # Skin inicial gratuita
		"skin_equipada": "default"
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
			break
	Database.save_users(users)

func get_coins() -> int:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return int(u["coins"])
	return 0
	
# --- NOVAS FUNÇÕES PARA O SISTEMA DE SKINS ---

# Verifica se o jogador já possui a skin
func has_skin(skin_id: String) -> bool:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			var lista = u.get("skins_compradas", ["default"])
			return skin_id in lista
	return false

# Adiciona uma skin à lista de comprados
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

# Equipa uma skin
func equip_skin(skin_id: String):
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			u["skin_equipada"] = skin_id
			break
	Database.save_users(users)

# Retorna qual skin está equipada atualmente
func get_equipped_skin() -> String:
	var users = Database.get_users()
	for u in users:
		if int(u["id_usuario"]) == user_id:
			return u.get("skin_equipada", "default")
	return "default"

# Desequipa a skin (volta para a padrão)
func unequip_skin():
	equip_skin("default")


func reset_user_data() -> void:
	print("Resetando dados do usuário para teste...")
	var empty_users: Array = []
	Database.save_users(empty_users)
	user_id = -1
	avatar_id = -1
	load_or_create_user()
	coins_changed.emit(0)
	print("Dados resetados com sucesso!")
