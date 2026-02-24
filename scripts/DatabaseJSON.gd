extends Node

const DB_PATH := "user://database.json"

var db: Dictionary = {}

func _ready():
	load_db()

func load_db():
	if FileAccess.file_exists(DB_PATH):
		var f := FileAccess.open(DB_PATH, FileAccess.READ)
		db = JSON.parse_string(f.get_as_text())
		f.close()
	else:
		db = {
			"USUARIO_AVATAR": [],
			"TAREFA": []
		}
		save_db()

func save_db():
	var f := FileAccess.open(DB_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(db, "\t"))
	f.close()

func get_or_create_user() -> Dictionary:
	if not db.has("USUARIO_AVATAR") or db["USUARIO_AVATAR"].size() == 0:
		var user := {
			"id_usuario": 1,
			"nivel_atual": 1,
			"xp_atual": 0,
			"coins": 0,
			"estrelas": 0,
			"ofensiva_individual": null,
			"avatar_id_FK_": 0,
			"nome": "User",
			"data_criacao_conta": Time.get_unix_time_from_system(),
			"id_avatar": 1,
			"acessorio": "",
			"cor_pele": "",
			"FK_roupa_roupa_PK": null,
			"cabelo": ""
		}

		db["USUARIO_AVATAR"] = [user]
		save_db()

	return db["USUARIO_AVATAR"][0]

func add_coins(amount: int):
	var user := get_or_create_user()
	user["coins"] += amount
	save_db()

func get_next_task_id() -> int:
	if not db.has("TAREFA") or db["TAREFA"].size() == 0:
		return 1
	return db["TAREFA"][-1]["id_tarefa"] + 1

func create_task(title: String, desc: String, user_id: int, avatar_id: int, reward: int):
	var id := get_next_task_id()

	var task := {
		"id_tarefa": id,
		"data_criacao": Time.get_unix_time_from_system(),
		"xp_recompensa": null,
		"coins_recompensa": reward,
		"titulo": title,
		"id_comodo": null,
		"id_criador": null,
		"id_executante": null,
		"prazo": null,
		"descricao": desc,
		"pendente": 1,
		"em_andamento": null,
		"concluida": 0,
		"data_conclusao": null,
		"FK_USUARIO_AVATAR_id_usuario": user_id,
		"FK_USUARIO_AVATAR_id_avatar": avatar_id
	}

	db["TAREFA"].append(task)
	save_db()

func complete_task(task_id: int) -> Dictionary:
	for t in db["TAREFA"]:
		if t["id_tarefa"] == task_id:
			t["concluida"] = 1
			t["pendente"] = 0
			t["data_conclusao"] = Time.get_unix_time_from_system()
			save_db()
			return t
	return {}

func get_pending_tasks(user_id: int, avatar_id: int) -> Array:
	var result: Array = []

	for t in db["TAREFA"]:
		if t["FK_USUARIO_AVATAR_id_usuario"] == user_id \
		and t["FK_USUARIO_AVATAR_id_avatar"] == avatar_id \
		and t["pendente"] == 1:
			result.append(t)

	return result
