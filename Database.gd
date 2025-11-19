extends Node

var db: SQLite = null

func _ready():
	db = SQLite.new()
	db.path = "res://database/A-tarefa-nao-acaba.db"

	if not db.open_db():
		push_error("ERRO AO ABRIR SQLITE!!!")
		return

	db.query("PRAGMA foreign_keys = ON;")
	print("DB carregado com sucesso:", db.path)

func exec(sql: String, params := []):
	return db.query_with_bindings(sql, params)

func fetch_all(sql: String, params := []):
	if not db.query_with_bindings(sql, params):
		return []
	return db.query_result

func fetch_one(sql: String, params := []):
	if not db.query_with_bindings(sql, params):
		return null
	var result = db.query_result
	if result.size() == 0:
		return null
	return result[0]
