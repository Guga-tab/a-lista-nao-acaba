extends Node

var db: SQLite = null


func _ready():
	db = SQLite.new()
	db.path = "user://A-tarefa-nao-acaba.db"

	if not db.open_db():
		push_error("ERRO AO ABRIR SQLITE!!!")
		return

	db.query("PRAGMA foreign_keys = ON;")
	print("DB carregado com sucesso:", db.path)

func query(sql: String):
	return db.query(sql)

func fetch_all(sql: String):
	if not db.query(sql):
		return []
	return db.query_result
