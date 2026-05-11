extends Node

const DB_PATH := "user://database.json"

var db: Dictionary = {}

func _ready():
	load_db()

func load_db():
	if FileAccess.file_exists(DB_PATH):
		var f := FileAccess.open(DB_PATH, FileAccess.READ)
		var parsed = JSON.parse_string(f.get_as_text())
		f.close()

		if typeof(parsed) == TYPE_DICTIONARY:
			db = parsed
		else:
			db = {}
	else:
		db = {}

	_ensure_structure()

func save_db():
	var f := FileAccess.open(DB_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(db, "\t"))
	f.close()


func _ensure_structure():
	if not db.has("USUARIO_AVATAR"):
		db["USUARIO_AVATAR"] = []

	if not db.has("TAREFA"):
		db["TAREFA"] = []


func get_users() -> Array:
	load_db()
	return db.get("USUARIO_AVATAR", [])


func save_users(users: Array):
	load_db()
	db["USUARIO_AVATAR"] = users
	save_db()


func get_tasks() -> Array:
	load_db()
	return db.get("TAREFA", [])


func save_tasks(tasks: Array):
	load_db()
	db["TAREFA"] = tasks
	save_db()


func get_next_task_id() -> int:
	var tasks = get_tasks()

	if tasks.is_empty():
		return 1

	return int(tasks[-1].get("id_tarefa", 0)) + 1
