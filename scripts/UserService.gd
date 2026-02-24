extends Node

const DB_PATH := "user://database.json"

var db := {}

var user_id: int = -1
var avatar_id: int = -1


func _ready():
	load_db()

# ================================
# Carregamento do JSON
# ================================
func load_db():
	if FileAccess.file_exists(DB_PATH):
		var f = FileAccess.open(DB_PATH, FileAccess.READ)
		var txt = f.get_as_text()
		f.close()

		var parsed = JSON.parse_string(txt)
		if typeof(parsed) == TYPE_DICTIONARY:
			db = parsed
		else:
			db = {}
	else:
		db = {}

	_ensure_structure()

func save_db():
	var f = FileAccess.open(DB_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(db, "\t"))
	f.close()

func _ensure_structure():
	if not db.has("USUARIO_AVATAR"):
		db["USUARIO_AVATAR"] = []

	if not db.has("TAREFA"):
		db["TAREFA"] = []

	save_db()

func load_or_create_user():
	if db["USUARIO_AVATAR"].size() > 0:
		var u = db["USUARIO_AVATAR"][0]
		user_id = int(u["id_usuario"])
		avatar_id = int(u["id_avatar"])
		return

	var user = {
		"id_usuario": 1,
		"id_avatar": 1,
		"nivel_atual": 1,
		"xp_atual": 0,
		"coins": 0,
		"estrelas": 0,
		"nome": "User",
		"data_criacao_conta": Time.get_unix_time_from_system()
	}

	db["USUARIO_AVATAR"].append(user)
	save_db()

	user_id = 1
	avatar_id = 1

func get_user_ids():
	return {
		"user_id": user_id,
		"avatar_id": avatar_id
	}

func add_coins(qtd: int):
	for u in db["USUARIO_AVATAR"]:
		if int(u["id_usuario"]) == user_id and int(u["id_avatar"]) == avatar_id:
			u["coins"] = int(u["coins"]) + qtd
			save_db()
			return


func get_coins() -> int:
	for u in db["USUARIO_AVATAR"]:
		if int(u["id_usuario"]) == user_id and int(u["id_avatar"]) == avatar_id:
			return int(u["coins"])
	return 0
