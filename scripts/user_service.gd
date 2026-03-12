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
		return

	var user = {
		"id_usuario": 1,
		"id_avatar": 1,
		"coins": 0,
		"estrelas": 0,
		"nome": "User",
		"data_criacao_conta": Time.get_unix_time_from_system()
	}

	users.append(user)
	Database.save_users(users)

	user_id = 1
	avatar_id = 1

func get_user_ids() -> Dictionary:
	return {
		"user_id": user_id,
		"avatar_id": avatar_id
	}

func add_coins(amount: int):
	var users = Database.get_users()

	for u in users:
		if int(u["id_usuario"]) == user_id and int(u["id_avatar"]) == avatar_id:
			u["coins"] = int(u["coins"]) + amount
			break

	Database.save_users(users)

func get_coins() -> int:
	var users = Database.get_users()

	for u in users:
		if int(u["id_usuario"]) == user_id and int(u["id_avatar"]) == avatar_id:
			return int(u["coins"])

	return 0
